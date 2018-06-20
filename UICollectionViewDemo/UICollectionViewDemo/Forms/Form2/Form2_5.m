//
//  Form2_5.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/20.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "Form2_5.h"

@implementation Form2_5

- (void)setSubviewLayout {
    
    UIView *view = self.contentView;
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0); //with is an optional semantic filler
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.3);
        make.height.equalTo(view).multipliedBy(1);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image1.mas_right);
        make.right.equalTo(view.mas_right);
        make.width.equalTo(view).multipliedBy(0.7);
        make.height.equalTo(view).multipliedBy(1);
    }];
}

@end
