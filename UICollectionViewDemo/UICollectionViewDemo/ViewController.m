//
//  ViewController.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "ViewController.h"
#import "CDFormCollectionControl.h"
#import "CDAlbumsSelectorControl.h"

#import "SimpleCVLayoutAttr.h"
#import "UIView+Extension.h"

@interface ViewController () {
	
	UICollectionView *_collectionView;
	
	NSInteger _sectionCount;
	NSInteger _rowCount;
    
    NSInteger _imageCount;
    
    CDFormCollectionControl *_formControl;
    CDAlbumsSelectorControl *_selectedControl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_sectionCount = 1;
    _imageCount = 0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

	//顶部样式
	[self loadFormControlAndSubviews];
    //下部相册选择器
    [self loadAlbumSelectControl];
    
    [_selectedControl loadAlbums];
}

- (void)loadFormControlAndSubviews {
	
	// 设置 flowLayout
	SimpleCVLayoutAttr *flowLayout = [[SimpleCVLayoutAttr alloc] init];
	
    _formControl = [[CDFormCollectionControl alloc] initWith:flowLayout];
    _formControl.collectionView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_formControl.collectionView];
    
    [_formControl.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        make.width.equalTo(self.view);
        make.height.mas_equalTo((self.view.height - 60)/2);
    }];
}

- (void)loadAlbumSelectControl {
    
    CDAlbumsFlowLayout *layout = [CDAlbumsFlowLayout new];
    _selectedControl = [[CDAlbumsSelectorControl alloc] initWith:layout superView:self.view];
    [self.view addSubview:_selectedControl.collectionView];
    
    [_selectedControl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_formControl.collectionView.mas_bottom);
    }];
    //更改相册时，clean FormCollection
    
    @WeakObj(self);
    [_selectedControl observeAlbumDidChange:^(PHCollection *collection) {
        
        @StrongObj(self);
        [self->_formControl formDidChanged:[NSArray new]];
    }];
    
    [_selectedControl observeAssetsDidChange:^(NSArray<PHAsset *> *assets) {
        
        @StrongObj(self);
        [self->_formControl formDidChanged:assets];
    }];
}
@end
