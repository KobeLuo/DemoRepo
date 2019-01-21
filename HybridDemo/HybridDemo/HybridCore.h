//
//  HybridCore.h
//  HybridDemo
//
//  Created by Kobe on 2019/1/21.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HybridCore : NSObject

/// the route which was be mirrored.
@property (nonatomic, strong, readonly) NSString *sourceRoute;

/// mirror route.
@property (nonatomic, strong, readonly) NSString *mirrorRoute;

- (instancetype)initWith:(NSString *)sourcePath mirror:(NSString *)mirrorRoute;
- (void)reMonitor:(NSString *)path;

- (void)clean;
@end
