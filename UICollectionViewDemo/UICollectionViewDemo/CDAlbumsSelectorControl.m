//
//  CDAlbumsSelectorControl.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/23.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "CDAlbumsSelectorControl.h"
#import "CDAssets.h"
#import "SimpleCollectionViewCell.h"

@interface CDAlbumsSelectorControl() <
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout> {
    
    CDAlbumDidChangeInvoke _invoke;
    NSArray *_albums;
}
@end

@implementation CDAlbumsSelectorControl

- (instancetype)initWith:(UICollectionViewFlowLayout *)layout {
    
    if (self = [super init]) {
        
        [self initialCollectionView:layout];
        _albums = [CDAssets getAllAlbums];
    }
    return  self;
}

- (void)initialCollectionView:(UICollectionViewFlowLayout *)layout {
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册 cell
    [_collectionView registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:@"SimpleCollectionViewCell"];
}



- (void)observeAlbumDidChange:(CDAlbumDidChangeInvoke)invoke {
    
    _invoke = invoke;
}

#pragma mark - /***** UICollectonView Delegate & Datasource *****/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimpleCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = _collectionView.height - 40;
    CGSize size = CGSizeMake(width, width);
    return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_invoke) {
        
        _invoke(_albums[indexPath.row]);
    }
}

@end
