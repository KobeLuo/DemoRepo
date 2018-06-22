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
#import "FormBaseCell.h"
@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
	
	UICollectionView *_collectionView;
	
	NSInteger _sectionCount;
	NSInteger _rowCount;
    
    NSInteger _imageCount;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_sectionCount = 1;
    _imageCount = 0;
    [self btnClicked:nil];
	
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
	[self.view addSubview:_collectionView];
	
	// 注册 cell
    [self registerCell];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
        make.width.equalTo(self.view);
        make.height.mas_equalTo((self.view.height - 44)/2);
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return _sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return _rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
    UICollectionViewCell *cell = [self loadCellWithIndexPath:indexPath];
//    SimpleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimpleCollectionViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
	
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
- (IBAction)btnClicked:(UIButton *)sender {
    
    _imageCount = 2 + arc4random()%4;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FormList" ofType:@"plist"];
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *key = [@"Form" stringByAppendingFormat:@"%ld",_imageCount];
    NSArray *array = info[key];
    
    _rowCount = array.count;
    
    [_collectionView reloadData];
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
    [cell setImageCount:_rowCount];
	
	return cell;
}

@end
