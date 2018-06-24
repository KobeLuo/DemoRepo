//
//  CDShowPhotosCell.h
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/24.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDShowPhotosCell : UICollectionViewCell

- (void)supportMultiSelect:(BOOL)support;

- (void)loadAsset:(PHAsset *)asset;
@end
