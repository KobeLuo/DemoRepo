//
//  CDAlbumsSelectorControl.h
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/23.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDAlbumShowControl.h"

typedef void (^CDAlbumDidChangeInvoke)(PHCollection *);

@interface CDAlbumsSelectorControl : NSObject

@property (nonatomic, readonly) UIView *view;
//相册选择
@property (nonatomic, readonly) UICollectionView *collectionView;

- (instancetype)initWith:(UICollectionViewFlowLayout *)layout
               superView:(UIView *)superView;

- (void)loadAlbums;
- (void)observeAlbumDidChange:(CDAlbumDidChangeInvoke)invoke;
- (void)observeAssetsDidChange:(photosDidchangeInvoke)invoke;
@end


@interface CDAlbumsFlowLayout: UICollectionViewFlowLayout
@end
