//
//  ViewController.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "ViewController.h"
#import "CDFormCollectionControl.h"

#import "SimpleCVLayoutAttr.h"
#import "UIView+Extension.h"

@interface ViewController () {
	
	UICollectionView *_collectionView;
	
	NSInteger _sectionCount;
	NSInteger _rowCount;
    
    NSInteger _imageCount;
    
    CDFormCollectionControl *_formControl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_sectionCount = 1;
    _imageCount = 0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self btnClicked:nil];
	
	[self initialCollectionView];
}

- (void)initialCollectionView {
	
	// 设置 flowLayout
	SimpleCVLayoutAttr *flowLayout = [[SimpleCVLayoutAttr alloc] init];
	
    _formControl = [[CDFormCollectionControl alloc] initWith:flowLayout];
    _formControl.collectionView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_formControl.collectionView];
    
    [_formControl.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        make.width.equalTo(self.view);
        make.height.mas_equalTo((self.view.height - 44)/2);
    }];
    
    [self btnClicked:nil];
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    NSInteger count = 2 + arc4random()%4;
    
    [_formControl formDidChanged:count];
}

@end
