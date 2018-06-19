//
//  ViewController.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "ViewController.h"
#import "SimpleCollectionViewCell.h"
#import "SimpleCVLayoutAttr.h"
#import "UIView+Extension.h"

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
	
	UICollectionView *_collectionView;
	
	NSInteger _sectionCount;
	NSInteger _rowCount;
	
	NSString *_identifier;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_sectionCount = 1;
	_rowCount = 5;
	_identifier = @"Simple Cell Identifier";
	
	[self initialCollectionView];
}

- (void)initialCollectionView {
	
	// 设置 flowLayout
	SimpleCVLayoutAttr *flowLayout = [[SimpleCVLayoutAttr alloc] init];
	
	// Do any additional setup after loading the view, typically from a nib.
	// 添加 collectionView，记得要设置 delegate 和 dataSource 的代理对象
	CGRect foo = self.view.frame;
	foo.origin.y = 30;
	foo.size.height = 200;
	_collectionView = [[UICollectionView alloc] initWithFrame:foo collectionViewLayout:flowLayout];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.backgroundColor = [UIColor redColor];
	[self.view addSubview:_collectionView];
	
	// 注册 cell
	[_collectionView registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:_identifier];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return _sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return _rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SimpleCollectionViewCell *cell = (SimpleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor blueColor];
	
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

- (CGSize)c1ollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	
	CGSize size = CGSizeZero;
	return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	
	return YES;
}

@end
