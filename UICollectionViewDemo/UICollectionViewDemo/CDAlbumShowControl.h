//
//  CDAlbumShowControl.h
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/24.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^photosDidchangeInvoke)(NSArray<PHAsset *> *);

@interface CDAlbumShowControl : NSObject

//相片展示
@property (nonatomic, readonly) UICollectionView *collectionView;

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)albumDidChange:(PHCollection *)collection;
- (void)observeSelectedPhotosChange:(photosDidchangeInvoke)invoke;

@end
