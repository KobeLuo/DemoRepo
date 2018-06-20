//
//  FormBaseCell.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/20/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "FormBaseCell.h"

@implementation FormBaseCell

- (instancetype)init {
	
	if (self = [super init]) { [self initialSubview]; }
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) { [self initialSubview]; }
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	
	if (self = [super initWithCoder:aDecoder]) { [self initialSubview]; }
	return self;
}

- (void)initialSubview {
	
	_image1 = [UIImageView new];
	_image2 = [UIImageView new];
	_image3 = [UIImageView new];
	_image4 = [UIImageView new];
	_image5 = [UIImageView new];
	_image6 = [UIImageView new];
	
	[self setSubviewLayout];
}

- (void)setSubviewLayout {}

- (void)setImageCount:(NSInteger)imageCount {
	
	NSInteger count = 1;
	for (UIImageView *imageV in @[_image1,_image2,_image3,_image4,_image5,_image6]) {
		
		imageV.hidden = (count > imageCount);
		count ++;
	}
}

@end
