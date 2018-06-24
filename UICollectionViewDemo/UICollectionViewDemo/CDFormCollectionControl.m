//
//  CDFormCollectionControl.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/23.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "CDFormCollectionControl.h"
#import "SimpleCollectionViewCell.h"
#import "FormBaseCell.h"


@interface CDFormCollectionControl() <
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout> {
    
    NSInteger _rowCount;
    NSInteger _imageCount;
    
    NSArray *_selectedAssets;
    
    UIImageView *_placeHolderView;
}
@end


@implementation CDFormCollectionControl

- (instancetype)initWith:(UICollectionViewFlowLayout *)layout {
    
    if (self = [super init]) { [self initialCollectionView:layout]; }
    return  self;
}

- (void)initialCollectionView:(UICollectionViewFlowLayout *)layout {
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册 cell
    [self registerCell];
    
    _placeHolderView = [[UIImageView alloc] init];
    _placeHolderView.image = [UIImage imageNamed:@"picCollage"];
    [_collectionView addSubview:_placeHolderView];
    
    CGFloat width = 100 * SCREEN_WIDTH/375.;
    [_placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_collectionView.mas_centerX);
        make.centerY.equalTo(_collectionView.mas_centerY);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width);
    }];
}

- (void)registerCell {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FormList" ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    
    for (NSString *key in info.allKeys) {
        
        NSArray *forms = info[key];
        for (NSString *form in forms) {
            
            [_collectionView registerClass:NSClassFromString(form) forCellWithReuseIdentifier:form];
        }
    }
}

- (void)formDidChanged:(NSArray *)assets {
    
    _selectedAssets = assets.copy;
    if (_selectedAssets.count == 1) {
        
        _selectedAssets = [NSArray arrayWithObjects:_selectedAssets.firstObject,_selectedAssets.firstObject, nil];
    }
    _imageCount = assets.count;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FormList" ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *key = [@"Form" stringByAppendingFormat:@"%ld",_imageCount];
    NSArray *array = info[key];
    
    _rowCount = array.count;
    
    _placeHolderView.hidden = _rowCount > 0;
    
    [self.collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [self loadCellWithIndexPath:indexPath];

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


- (CGSize)c1ollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = CGSizeZero;
    return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FormBaseCell *cell = (FormBaseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGAffineTransform transf = cell.transform;
    transf = CGAffineTransformScale(transf, 0.98, 0.98);
    
    [UIView animateWithDuration:0.1 animations:^{
        
        cell.transform = transf;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FormBaseCell *cell = (FormBaseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGAffineTransform transf = cell.transform;
    transf = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        cell.transform = transf;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"indexPath.row:%ld",indexPath.row);
    
    //push vc
}

- (UICollectionViewCell *)loadCellWithIndexPath:(NSIndexPath *)indexPath {
    
    NSString *formClassStr = [@"Form" stringByAppendingFormat:@"%ld_%ld",_imageCount,indexPath.row];
    //    NSString *formClassStr = [@"Form" stringByAppendingFormat:@"%ld_%ld",_imageCount,0];
    FormBaseCell *cell = (FormBaseCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:formClassStr forIndexPath:indexPath];
    [cell setImageCount:_selectedAssets.count];
    [cell loadAssets:_selectedAssets];
    
    return cell;
}


@end
