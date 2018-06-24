//
//  SimpleCollectionViewCell.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "SimpleCollectionViewCell.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
@implementation SimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) { [self initialSubview]; }
    return self;
}

- (void)prepareForReuse {
    
	[super prepareForReuse];
}

- (void)initialSubview {
    
    _image1 = [UIImageView new];
    _image2 = [UIImageView new];
    
    UIView *view = self.contentView;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 1.f;
    view.layer.masksToBounds = YES;
    
    NSArray *views = @[_image1,_image2];
    NSArray *colors = @[[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor grayColor]];
    
    NSInteger index = 0;
    for (UIView *view in views) {
        
        view.backgroundColor = colors[index ++];
        
        [self.contentView addSubview:view];
    }
    
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    UIView *view = self.contentView;
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0); //with is an optional semantic filler
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.5);
        make.height.equalTo(view.mas_height).multipliedBy(0.5);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view.mas_top);
        make.right.equalTo(view.mas_right);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
}



@end
