//
//  Form4_8.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/20.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "Form4_8.h"

@implementation Form4_8

- (void)setSubviewLayout {
    
    UIView *view = self.contentView;
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0); //with is an optional semantic filler
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.equalTo(view).multipliedBy(1);
        make.height.equalTo(view).multipliedBy(0.2);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.image1.mas_bottom);
        make.left.equalTo(view.mas_left);
        make.width.equalTo(view).multipliedBy(0.5);
        make.height.equalTo(view).multipliedBy(0.6);
    }];
    
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image2.mas_right);
        make.top.equalTo(self.image2.mas_top);
        make.width.equalTo(self.image2);
        make.height.equalTo(self.image2);
    }];
    
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
        make.width.equalTo(view).multipliedBy(1);
        make.height.equalTo(view).multipliedBy(0.2);
    }];
}

@end
