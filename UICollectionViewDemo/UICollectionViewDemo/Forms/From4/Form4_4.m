//
//  Form4_4.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/20.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "Form4_4.h"

@implementation Form4_4

- (void)setSubviewLayout {
    
    UIView *view = self.contentView;
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0); //with is an optional semantic filler
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.333333);
        make.height.equalTo(view).multipliedBy(0.5);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image1.mas_right);
        make.top.equalTo(view.mas_top);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
    
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image2.mas_right);
        make.top.equalTo(view.mas_top);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
    
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
        make.width.equalTo(view).multipliedBy(1);
        make.height.equalTo(view).multipliedBy(0.5);
    }];
}

@end
