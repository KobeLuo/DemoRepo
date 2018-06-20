//
//  Form2_1.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/20.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "Form2_1.h"

@implementation Form2_1

- (void)setSubviewLayout {
    
    UIView *view = self.contentView;
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0); //with is an optional semantic filler
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.5);
        make.height.equalTo(view).multipliedBy(1);
    }];
    
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image1.mas_right);
        make.top.equalTo(view.mas_top);
        make.width.equalTo(self.image1);
        make.height.equalTo(view).multipliedBy(1);
    }];
}

@end
