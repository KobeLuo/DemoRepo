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
#import "CDAlbumCell.h"

#define BOTTOM_BAR_HEIGHT 60
#define ALBUM_PICKER_HEIGHT 130

@interface CDAlbumsSelectorControl() <
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout> {
    
    CDAlbumDidChangeInvoke _invoke;
    photosDidchangeInvoke _assetsInvoke;
    NSArray *_albums;
    
    UIView *_shadowVoew;
    UIView *_menuBarView;
    
    UIButton *_photoPickerBtn;
    
    PHCollection *_currentCollection;
    
    CDAlbumShowControl *_photoControl;
    
    UIView *_superView;
    UIView *_shadowView;
}

@end

@implementation CDAlbumsSelectorControl

- (instancetype)initWith:(UICollectionViewFlowLayout *)layout
               superView:(UIView *)superView {
    
    if (self = [super init]) {
        
        _view = [UIView new];
        _view.backgroundColor = superView.backgroundColor;
        [superView addSubview:_view];
        _superView = superView;
        
        //相册选取collectionView;
        [self loadCollectionView:layout];
        //照片展示
        [self loadPhotosPickControl];
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = HEX_RGBA(0x000000, 0);
        _shadowView.userInteractionEnabled = NO;
        [_superView addSubview:_shadowView];
        
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(superView);
            make.size.equalTo(superView);
        }];
        
        //底部menubar.
        [self loadMenuBarView];
    }
    return  self;
}

- (void)loadMenuBarView {
    
    _menuBarView = [UIView new];
    _menuBarView.backgroundColor = [UIColor whiteColor];
    [_superView addSubview:_menuBarView];
    [_superView bringSubviewToFront:_menuBarView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"CLOSE" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [closeBtn setTitleColor:RGB(123, 123, 123) forState:UIControlStateNormal];
    [closeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    [_menuBarView addSubview:closeBtn];

    _photoPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoPickerBtn setTitleColor:RGB(123, 123, 123) forState:UIControlStateNormal];
    _photoPickerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _photoPickerBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_photoPickerBtn setTitle:@"All photos ^" forState:UIControlStateNormal];
    [_photoPickerBtn addTarget:self action:@selector(photoPickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuBarView addSubview:_photoPickerBtn];
    
    //layout setting.
    [_menuBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_view.mas_left);
        make.bottom.equalTo(_view.mas_bottom);
        make.right.equalTo(_view.mas_right);
        make.height.mas_equalTo(BOTTOM_BAR_HEIGHT);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_menuBarView.mas_left);
        make.bottom.equalTo(_menuBarView.mas_bottom);
        make.width.mas_equalTo(150);
        make.height.equalTo(_menuBarView);
    }];
    
    [_photoPickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(closeBtn.mas_right);
        make.bottom.equalTo(_menuBarView.mas_bottom);
        make.right.equalTo(_menuBarView.mas_right);
        make.height.equalTo(_menuBarView);
    }];
}

- (void)loadCollectionView:(UICollectionViewFlowLayout *)layout {
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 注册 cell
    [_collectionView registerClass:[CDAlbumCell class] forCellWithReuseIdentifier:@"CDAlbumCell"];
    [_superView addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_view.mas_bottom);
        make.left.equalTo(_view);
        make.right.equalTo(_view);
        make.height.mas_equalTo(ALBUM_PICKER_HEIGHT);
    }];
}

- (void)loadPhotosPickControl {
    
    _photoControl = [[CDAlbumShowControl alloc] initWithSuperView:_view];
    
    [_photoControl observeSelectedPhotosChange:^(NSArray<PHAsset *> *assets) {
        
        if (_assetsInvoke) { _assetsInvoke(assets); }
    }];
    
    [_view addSubview:_photoControl.collectionView];
    
    [_photoControl.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_view.mas_left);
        make.right.equalTo(_view.mas_right);
        make.top.equalTo(_view.mas_top);
        make.bottom.equalTo(_view).with.offset(-BOTTOM_BAR_HEIGHT);
    }];
}

- (void)closeAction:(id)sender {
    
    //close action
}

- (void)photoPickerAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [self showAlbumsCollectionView:sender.selected];
}

- (void)showAlbumsCollectionView:(BOOL)show {
    
    CGFloat alpha = 0.;
    CGFloat offset = 0;
    BOOL interaction = NO;
    if (show) {
        
        alpha = 0.3;
        offset = - (BOTTOM_BAR_HEIGHT + ALBUM_PICKER_HEIGHT);
        interaction = YES;
        
        [_collectionView reloadData];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _shadowView.backgroundColor = HEX_RGBA(0x000000, alpha);
        _shadowView.userInteractionEnabled = interaction;
        
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(_view.mas_bottom).with.offset(offset);
        }];
    }];
}

- (void)updatePhotoPickerBtnTitleWith:(PHCollection *)collection {
    
    NSString *title = [collection.localizedTitle stringByAppendingString:@" ^"];
    [_photoPickerBtn setTitle:title forState:UIControlStateNormal];
}

- (void)loadAlbums {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 这里便是无访问权限
        //可以弹出个提示框，叫用户去设置打开相册权限
    }  else {
        //这里就是用权限
    }
    
    _albums = [self filterEmptyAlbum:[CDAssets getAllAlbums]];
    
    [self didPickerAlbum:_albums[0]];
}

- (void)didPickerAlbum:(PHAssetCollection *)cln {
    
    _currentCollection = cln;
    [_photoControl albumDidChange:_currentCollection];
    [self updatePhotoPickerBtnTitleWith:_currentCollection];
}

- (NSArray *)filterEmptyAlbum:(NSArray *)albums {
    
    NSMutableArray *arr = [NSMutableArray new];
    for (PHAssetCollection *collection in albums) {
        
        if ([collection isKindOfClass:[PHAssetCollection class]] && [CDAssets getPhotosFromAlbum:collection].count > 0) {
            
            [arr addObject:collection];
        }
    }
    
    [arr sortUsingComparator:^NSComparisonResult(PHAssetCollection *obj1, PHAssetCollection *obj2) {
        
        if ([CDAssets getPhotosFromAlbum:obj1].count > [CDAssets getPhotosFromAlbum:obj2].count) {
            
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    return arr;
}

- (void)observeAlbumDidChange:(CDAlbumDidChangeInvoke)invoke { _invoke = invoke; }
- (void)observeAssetsDidChange:(photosDidchangeInvoke)invoke { _assetsInvoke = invoke; }

#pragma mark - /***** UICollectonView Delegate & Datasource *****/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CDAlbumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDAlbumCell" forIndexPath:indexPath];
    
    if (_albums.count > indexPath.row) {
    
        PHAssetCollection *cln = _albums[indexPath.row];
        [cell loadAssets:cln didSelected:(cln == _currentCollection)];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = _collectionView.height - 20;
    CGSize size = CGSizeMake(width, width);
    return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self didPickerAlbum:_albums[indexPath.row]];
    
    _photoPickerBtn.selected = !_photoPickerBtn.selected;
    [self showAlbumsCollectionView:_photoPickerBtn.selected];
    
    if (_invoke) {  _invoke(_currentCollection); }
}



@end





