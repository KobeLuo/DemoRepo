//
//  CDPhotoPickerView.h
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/21/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CDImagePickerResult)(NSArray *);

@interface CDPhotoPickerView : UIView

- (void)observePickerViewDidPickerImageWithBlock: (CDImagePickerResult)result;
- (void)observePickDidCancelWithBlock:(void (^)(void))block;
@end
