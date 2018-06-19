//
//  UIView+Extension.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)x { return self.frame.origin.x; }
- (CGFloat)y { return self.frame.origin.y; }
- (CGFloat)height { return self.frame.size.height; }
- (CGFloat)width { return self.frame.size.width; }
- (CGFloat)right { return self.x + self.width; }
- (CGFloat)bottom { return self.y + self.height; }
- (CGSize)center { return CGSizeMake(self.x + self.width/2, self.y + self.height/2); }
- (CGSize)size { return self.frame.size; }
@end
