//
//  CDAssets.m
//  CameraD
//
//  Created by ANine on 2018/6/23.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "CDAssets.h"
#import <Photos/Photos.h>
#import <objc/runtime.h>
@implementation CDAssets

+ (NSArray *)getAllAlbums {
    
    NSMutableArray *array = [NSMutableArray new];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [array addObjectsFromArray:smartAlbums];
    [array addObjectsFromArray:userAlbums];
    
    return array;
}

+ (NSArray *)getPhotosFromAlbum:(PHAssetCollection *)collection {
    
    return [PHAsset fetchAssetsInAssetCollection:collection options:nil];
}

+ (NSMutableArray *)getAllPhoto {
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = NO;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(screenSize.width*scale, screenSize.height*scale) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if (result) { [arr addObject:result]; }
        }];
    }
    
    return arr;
}

+ (UIImage *)getImageFrom:(PHAsset *)asset size:(CGSize)size {
    
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
    opt.synchronous = YES;
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    __block UIImage *image;
    [imageManager requestImageForAsset:asset
                            targetSize:size
                           contentMode:PHImageContentModeAspectFit
                               options:opt
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                             image = result;
    }];
    return image;
}

// 指定相册名称,获取相册
+ (PHAssetCollection *)fetchAssetCollection:(NSString *)title
{
    // 获取相簿中所有自定义相册
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in result) {
        if ([title isEqualToString:assetCollection.localizedTitle]) {
            return assetCollection;
        }
    }
    return nil;
}

// 添加图片到自己相册
+ (void)savePhoto:(UIImage *)image completion:(saveResultInvoke)invoke {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.创建图片请求类(创建系统相册中新的图片)PHAssetCreationRequest
        // 把图片放在系统相册
        PHAssetCreationRequest *assetCreationRequest = [PHAssetCreationRequest creationRequestForAssetFromImage:image];
        
        // 2.创建相册请求类(修改相册)PHAssetCollectionChangeRequest
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest = nil;
        
        // 获取之前相册
        PHAssetCollection *assetCollection = [self fetchAssetCollection:@"百思不得姐"];
        
        // 判断是否已有相册
        if (assetCollection) {
            // 如果存在已有同名相册   指定这个相册,创建相册请求修改类
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else {  //不存在,创建新的相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"百思不得姐"];
        }
        // 3.把图片添加到相册中
        // NSFastEnumeration:以后只要看到这个,就可以表示数组
        //assetCreationRequest.placeholderForCreatedAsset 图片请求类占位符(相当于一个内存地址)
        //因为creationRequestForAssetFromImage方法是异步实行的,在这里不能保证 assetCreationRequest有值
        
        [assetCollectionChangeRequest addAssets:@[assetCreationRequest.placeholderForCreatedAsset]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (invoke) { invoke(success,error); }
    }];
}



@end


@implementation PHAsset(CDExtension)

static char CD_ASSET_SELECTED_KEY;
static char CD_ASSET_SELECTED_INTERVAL_KEY;

- (void)setSelected:(BOOL)selected {
    
    objc_setAssociatedObject(self, &CD_ASSET_SELECTED_KEY, @(selected), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)selected {
    
    return [objc_getAssociatedObject(self, &CD_ASSET_SELECTED_KEY) boolValue];
}

- (void)setSelectedInterval:(NSTimeInterval)selectedInterval {

    objc_setAssociatedObject(self, &CD_ASSET_SELECTED_INTERVAL_KEY, @(((long)(selectedInterval*10))%100000), OBJC_ASSOCIATION_RETAIN);
}

- (NSTimeInterval)selectedInterval {
    
    NSTimeInterval interval = [objc_getAssociatedObject(self, &CD_ASSET_SELECTED_INTERVAL_KEY) doubleValue];
    return interval;
}
@end

