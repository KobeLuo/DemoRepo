//
//  FileWatcher.h
//  HybridDemo
//
//  Created by Kobe on 2019/1/11.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileWatcher : NSOperation {
    
    CFRunLoopRef _loop;
}
- (instancetype)initWithWatchPath:(NSString *)watchPath;

@end
