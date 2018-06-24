//
//  CDAlbumCell.h
//  UICollectionViewDemo
//
//  Created by ANine on 2018/6/24.
//  Copyright © 2018年 KobeLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDAlbumCell : UICollectionViewCell

- (void)loadAssets:(PHAssetCollection *)collection didSelected:(BOOL)selected;

@end

@interface CDAlbumLayout : UICollectionViewFlowLayout

@end
