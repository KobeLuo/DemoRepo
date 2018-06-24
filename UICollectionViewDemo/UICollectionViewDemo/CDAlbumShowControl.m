//
//  CDAlbumShowControl.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/24.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "CDAlbumShowControl.h"
#import "CDShowPhotosCell.h"


@interface CDPhotoShowLayout : UICollectionViewFlowLayout@end
@implementation CDPhotoShowLayout
- (instancetype)init {
    
    if (!(self = [super init])) { return nil; }
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 5;
    
    return self;
}
@end

@interface CDAlbumShowControl() <
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
> {
    
    photosDidchangeInvoke _invoke;
    NSArray *_assets;
}
@end

@implementation CDAlbumShowControl

- (instancetype)initWithSuperView:(UIView *)superView {
    
    if (self = [super init]) {
        
        [self initialCollectionView];
        
        _collectionView.backgroundColor = superView.backgroundColor;
    }
    return self;
}

- (void)initialCollectionView {
    
    CDPhotoShowLayout *layout = [CDPhotoShowLayout new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册 cell
    Class cls = [CDShowPhotosCell class];
    [_collectionView registerClass:cls forCellWithReuseIdentifier:NSStringFromClass(cls)];
}


#pragma mark - /***** public methods *****/
- (void)albumDidChange:(PHCollection *)collection {
    
    _assets = [CDAssets getPhotosFromAlbum:collection];
    
    [_collectionView reloadData];
    // load photos from collection
}

- (void)observeSelectedPhotosChange:(photosDidchangeInvoke)invoke { _invoke = invoke; }

#pragma mark - /***** UICollectonView Delegate & Datasource *****/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CDShowPhotosCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDShowPhotosCell" forIndexPath:indexPath];
    
    [cell loadAsset:_assets[indexPath.row]];
    [cell supportMultiSelect:YES];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (_collectionView.width - 15)/4;
    CGSize size = CGSizeMake(width, width);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PHAsset *asset = _assets[indexPath.row];
    NSArray *selectedAssets = [self selectedPhotos];
    BOOL needReload = YES;
    
    if (asset.selected == NO && selectedAssets.count >= 6) {
        
        needReload = NO;
    }
    if (needReload) {
        
        asset.selected = !asset.selected;
        if (asset.selected == YES) {
            
            asset.selectedInterval = [[NSDate date] timeIntervalSince1970];
        }
        
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        selectedAssets = [self selectedPhotos];
        
        if (_invoke) {
            
            _invoke(selectedAssets);
        }
    }
}

- (NSArray *)selectedPhotos {
    
    NSMutableArray *arr = [NSMutableArray new];
    for (PHAsset *asset in _assets) {
        
        if (asset.selected == YES) {
            
            [arr addObject:asset];
        }
    }

    [arr sortUsingComparator:^NSComparisonResult(PHAsset *obj1, PHAsset *obj2) {
        
        if (obj1.selectedInterval > obj2.selectedInterval) {
            
            return NSOrderedDescending ;
        }
        return NSOrderedAscending;
    }];
    
    return arr;
}

@end
