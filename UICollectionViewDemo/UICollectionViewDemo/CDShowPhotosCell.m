//
//  CDShowPhotosCell.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/24.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "CDShowPhotosCell.h"
@interface CDShowPhotosCell() {
    
    BOOL _multiSupport;
    UIImageView *_imageV;
    UIButton *_selectedBtn;
}
@end


@implementation CDShowPhotosCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) { [self initialSubviews]; }
    return self;
}

- (void)initialSubviews {
    
    _imageV = [UIImageView new];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageV];
    self.contentView.clipsToBounds = YES;
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn setImage:[UIImage imageNamed:@"btnCollageUnSelected"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"btnCollageSelected"] forState:UIControlStateSelected];
    _selectedBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectedBtn];
    
    UIView *view = self.contentView;
    
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(view);
        make.top.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right).with.offset(-3);
        make.bottom.equalTo(view.mas_bottom).with.offset(-3);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}

- (void)supportMultiSelect:(BOOL)support {
    
    _multiSupport = support;
    _selectedBtn.hidden = !support;
}

- (void)loadAsset:(PHAsset *)asset {
    
    _imageV.image = [CDAssets getImageFrom:asset size:_imageV.size];
    _selectedBtn.selected = asset.selected;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    _imageV.image = nil;
    _selectedBtn.selected = NO;
}
@end
