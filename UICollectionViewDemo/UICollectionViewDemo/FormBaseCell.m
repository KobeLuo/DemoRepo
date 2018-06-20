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

// 调用在view 内部，而不是viewcontroller
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)initialSubview {
	
	_image1 = [UIImageView new];
	_image2 = [UIImageView new];
	_image3 = [UIImageView new];
	_image4 = [UIImageView new];
	_image5 = [UIImageView new];
	_image6 = [UIImageView new];
	
    UIView *view = self.contentView;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds = YES;
    
    NSArray *views = @[_image1,_image2,_image3,_image4,_image5,_image6];
    NSArray *colors = @[[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor grayColor]];
    
    NSInteger index = 0;
    for (UIView *view in views) {
        
        view.backgroundColor = colors[index ++];

        [self.contentView addSubview:view];
    }
    
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
