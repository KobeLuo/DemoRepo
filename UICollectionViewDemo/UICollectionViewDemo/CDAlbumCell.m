//
//  CDAlbumCell.m
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/24.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import "CDAlbumCell.h"

@interface CDAlbumCell() {
    
    UIImageView *_imageV;
    UILabel *_titleLabel;
    
    PHAssetCollection *_collection;
}
@end

@implementation CDAlbumCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) { [self initialSubviews]; }
    return self;
}

- (void)initialSubviews {
    
    _imageV = [UIImageView new];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.clipsToBounds = YES;
    _imageV.backgroundColor = HEX_RGBA(0x111111, 0.6);
    [self.contentView addSubview:_imageV];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:11];
    _titleLabel.textColor = RGB(63, 63, 63);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    
    UIView *view = self.contentView;
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(view);
        make.top.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view).with.offset(-20);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(view);
        make.bottom.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(20);
    }];
}

- (void)loadAssets:(PHAssetCollection *)collection didSelected:(BOOL)selected {
    
    _collection = collection;
    _titleLabel.text = collection.localizedTitle;
    
    NSArray *ary = [CDAssets getPhotosFromAlbum:collection];
    if (ary && ary.count > 0) {
        
       _imageV.image = [CDAssets getImageFrom:ary.firstObject size:_imageV.size];
    }
    
    self.contentView.alpha = selected ? 1 : 0.6;
}

@end

@implementation CDAlbumLayout

- (instancetype)init {
    
    if (!(self = [super init])) { return nil; }
    
    //    self.minimumInteritemSpacing = 40;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.itemSize = CGSizeMake(10, 100);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

@end

