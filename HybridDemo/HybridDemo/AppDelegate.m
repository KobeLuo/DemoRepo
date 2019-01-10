//
//  AppDelegate.m
//  HybridDemo
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "AppDelegate.h"
#import "FileOperateServer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString *rootpath = @"/Users/naver/Development/Research/HybridSync/HybridHostAlias";
    
    if (NO == [NSFileManager.defaultManager fileExistsAtPath:rootpath]) {
        
        [NSFileManager.defaultManager createDirectoryAtPath:rootpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
