//
//  UIView+Extension.h
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, readonly)CGFloat x;
@property (nonatomic, readonly)CGFloat y;
@property (nonatomic, readonly)CGFloat height;
@property (nonatomic, readonly)CGFloat width;
@property (nonatomic, readonly)CGFloat right;
@property (nonatomic, readonly)CGFloat bottom;
@property (nonatomic, readonly)CGSize center;
@property (nonatomic, readonly)CGSize size;

@end
