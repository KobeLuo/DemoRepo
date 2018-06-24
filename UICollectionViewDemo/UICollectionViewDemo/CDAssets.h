//
//  CDAssets.h
//  CameraD
//
//  Created by ANine on 2018/6/23.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void (^saveResultInvoke)(BOOL, NSError*);

@interface CDAssets : NSObject

+ (NSArray *)getAllAlbums;
+ (NSMutableArray *)getAllPhoto;

+ (NSArray *)getPhotosFromAlbum:(PHAssetCollection *)collection;
+ (UIImage *)getImageFrom:(PHAsset *)asset size:(CGSize)size;
+ (void)savePhoto:(UIImage *)image completion:(saveResultInvoke)invoke;

@end


@interface PHAsset(CDExtension)

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) NSTimeInterval selectedInterval;

@end

