//
//  Form4_6.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/20.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "Form4_6.h"

@implementation Form4_6

- (void)setSubviewLayout {
    
    UIView *view = self.contentView;
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0); //with is an optional semantic filler
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.5);
        make.height.equalTo(view).multipliedBy(0.35);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image1.mas_left);
        make.top.equalTo(self.image1.mas_bottom);
        make.width.equalTo(self.image1);
        make.bottom.equalTo(view.mas_bottom);
    }];
    
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right);
        make.top.equalTo(view.mas_top);
        make.width.equalTo(self.image1);
        make.height.equalTo(view).multipliedBy(0.65);
    }];
    
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image3.mas_left);
        make.top.equalTo(self.image3.mas_bottom);
        make.width.equalTo(self.image1);
        make.bottom.equalTo(view.mas_bottom);
    }];
}

@end
