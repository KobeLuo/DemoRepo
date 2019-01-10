//
//  NSString+Extension.h
//  HybridDemo
//
//  Created by Kobe on 2019/1/10.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

- (NSString *)runAsCommand;
- (BOOL)createSparseFileWithApparentSize:(unsigned long long)size;
@end

NS_ASSUME_NONNULL_END
