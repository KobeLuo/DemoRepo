//
//  Form6_0.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/20.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "Form6_0.h"

@implementation Form6_0

- (void)setSubviewLayout {
    
    UIView *view = self.contentView;
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0); //with is an optional semantic filler
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.5);
        make.height.equalTo(view).multipliedBy(0.333333);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view.mas_top);
        make.right.equalTo(view.mas_right);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
    
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.image1.mas_bottom);
        make.left.equalTo(self.image1.mas_left);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
    
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.image2.mas_bottom);
        make.left.equalTo(self.image2.mas_left);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
    
    [self.image5 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.image3.mas_bottom);
        make.left.equalTo(self.image3.mas_left);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
    
    [self.image6 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.image4.mas_bottom);
        make.left.equalTo(self.image4.mas_left);
        make.width.equalTo(self.image1);
        make.height.equalTo(self.image1);
    }];
}

@end
