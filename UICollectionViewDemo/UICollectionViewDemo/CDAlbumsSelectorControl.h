//
//  CDAlbumsSelectorControl.h
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/23.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CDAlbumDidChangeInvoke)(PHCollection *);

@interface CDAlbumsSelectorControl : NSObject

- (instancetype)initWith:(UICollectionViewFlowLayout *)layout;

@property (nonatomic, readonly) UICollectionView *collectionView;

- (void)observeAlbumDidChange:(CDAlbumDidChangeInvoke)invoke;

@end
