//
//  CDPhotoPickerView.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/21/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "CDPhotoPickerView.h"
#import <Masonry/Masonry.h>
#import <Photos/Photos.h>

#ifndef HEX_RGB

#define HEX_RGB(rgbValue) HEX_RGBA(rgbValue, 1)
#define HEX_RGBA(rgbValue, alphaValue)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alphaValue)]

#endif

#ifndef RGB
#define RGB(redValue, greenValue, blueValue) RGBA(redValue, greenValue, blueValue, 1)
#define RGBA(redValue, greenValue, blueValue, alphaValue) [UIColor colorWithRed:(float)redValue/255.0 green:(float)greenValue/255.0 blue:(float)blueValue/255.0 alpha:alphaValue]
#endif


@interface CDPhotoPickerView() {
	
	CDImagePickerResult _resultInvoke;
	UICollectionView *_photosCollectionView;
	UIView *_itemBar;
	
	void (^_cancelBlock)(void);
	UIButton *_albumsBtn;
}
@end

@implementation CDPhotoPickerView

- (instancetype)init {
	
	if (self = [super init]) { [self initial]; }
	return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) { [self initial]; }
	return self;
}

- (void)observePickerViewDidPickerImageWithBlock: (CDImagePickerResult)result {
	
	_resultInvoke = result;
}

- (void)observePickDidCancelWithBlock:(void (^)(void))block {
	
	_cancelBlock = block;
}

#pragma mark - private
- (void)initial {
	
	[self loadItemBar];
	[self loadPhotoCollectionView];
}

- (void)loadItemBar {
	
	_itemBar = [UIView new];
	_itemBar.backgroundColor = [UIColor whiteColor];
	[self addSubview:_itemBar];
	[_itemBar mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.bottom.equalTo(self.mas_bottom);
		make.left.equalTo(self.mas_left);
		make.width.equalTo(self);
		make.height.mas_equalTo(44);
	}];
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setTitle:@"CANCEL" forState:UIControlStateNormal];
	[btn setTitleColor:RGB(123, 123, 123) forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(cancelPicker:) forControlEvents:UIControlEventTouchUpInside];
	[_itemBar addSubview:btn];
	
	_albumsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[_albumsBtn setTitle:@"All Photos  △" forState:UIControlStateNormal];
	[_albumsBtn setTitle:@"All Photos  ▽" forState:UIControlStateSelected];
	[_albumsBtn setTitleColor:RGB(123, 123, 123) forState:UIControlStateNormal];
	[_albumsBtn addTarget:self action:@selector(pickerAlbum:) forControlEvents:UIControlEventTouchUpInside];
	[_itemBar addSubview:_albumsBtn];
}

- (void)cancelPicker:(id)sender {
	
	if (_cancelBlock) { _cancelBlock(); }
}

- (void)pickerAlbum:(UIButton *)sender {
	
	sender.selected = !sender.selected;
}

- (void)loadSystemAlbum {
	
	
}

- (void)loadPhotoCollectionView {
	
	
}
@end
