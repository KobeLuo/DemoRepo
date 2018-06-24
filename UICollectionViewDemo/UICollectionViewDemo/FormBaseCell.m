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
    view.layer.borderWidth = 4.f;
    view.layer.masksToBounds = YES;
    view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2.f, 2.f);
    view.layer.shadowOpacity = 0.5;
    view.clipsToBounds = NO;
    NSArray *views = @[_image1,_image2,_image3,_image4,_image5,_image6];
    
    for (UIView *view in views) {
        
        [self.contentView addSubview:view];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
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

- (void)loadAssets:(NSArray *)assets {
    
    _image5.backgroundColor = [UIColor redColor];
    
    NSInteger index = 0;
    for (UIImageView *imageV in @[_image1,_image2,_image3,_image4,_image5,_image6]) {
        
        if (assets.count > index) {
            
            imageV.image = [CDAssets getImageFrom:assets[index] size:imageV.size];
            
            NSLog(@"imageV.frame:%@",[NSValue valueWithCGRect:imageV.frame]);
        }else {
            
            break;
        }
        index ++;
    }
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    for (UIImageView *img in @[_image1,_image2,_image3,_image4,_image5,_image6]) { img.image = nil; }
}
@end
