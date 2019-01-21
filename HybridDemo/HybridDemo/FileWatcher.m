//
//  FileWatcher.m
//  HybridDemo
//
//  Created by Kobe on 2019/1/11.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "FileWatcher.h"

@interface FileWatcher() {
    
    NSString *_watchPath;
}

@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isConcurrent;
@property (nonatomic) BOOL isFinished;

@end

static void watchCallback(ConstFSEventStreamRef streamRef,
                          void *clientCallBackInfo,
                          size_t numEvents,
                          void *eventPaths,
                          const FSEventStreamEventFlags eventFlags[],
                          const FSEventStreamEventId eventIds[]) {
    
    char **paths = eventPaths;
    
    for (int i=0; i < numEvents; i ++) {
        
        int flag = eventFlags[i];
        printf("Change %llu in %s, flags %u\n", eventIds[i], paths[i], flag);
        
        if (flag == kFSEventStreamEventFlagNone) {
            NSLog(@"kFSEventStreamEventFlagNone");
        } else if (flag & kFSEventStreamEventFlagMustScanSubDirs) {
            NSLog(@"kFSEventStreamEventFlagMustScanSubDirs");
        } else if (flag & kFSEventStreamEventFlagUserDropped) {
            NSLog(@"kFSEventStreamEventFlagUserDropped");
        } else if (flag & kFSEventStreamEventFlagKernelDropped) {
            NSLog(@"kFSEventStreamEventFlagKernelDropped");
        } else if (flag & kFSEventStreamEventFlagEventIdsWrapped) {
            NSLog(@"kFSEventStreamEventFlagEventIdsWrapped");
        } else if (flag & kFSEventStreamEventFlagHistoryDone) {
            NSLog(@"kFSEventStreamEventFlagHistoryDone");
        } else if (flag & kFSEventStreamEventFlagRootChanged) {
            NSLog(@"kFSEventStreamEventFlagRootChanged");
            
        } else if (flag & kFSEventStreamEventFlagMount) {
            NSLog(@"kFSEventStreamEventFlagMount");
        } else if (flag & kFSEventStreamEventFlagUnmount) {
            NSLog(@"kFSEventStreamEventFlagUnmount");
        } else if (flag & kFSEventStreamEventFlagItemCreated) {
            NSLog(@"kFSEventStreamEventFlagItemCreated");
        } else if (flag& kFSEventStreamEventFlagItemRemoved) {
            NSLog(@"kFSEventStreamEventFlagItemRemoved");
        } else if (flag & kFSEventStreamEventFlagItemInodeMetaMod) {
            NSLog(@"kFSEventStreamEventFlagItemInodeMetaMod");
        } else if (flag & kFSEventStreamEventFlagItemRenamed) {
            NSLog(@"kFSEventStreamEventFlagItemRenamed");
        } else if (flag & kFSEventStreamEventFlagItemModified) {
            NSLog(@"kFSEventStreamEventFlagItemModified");
        } else if (flag & kFSEventStreamEventFlagItemFinderInfoMod) {
            NSLog(@"kFSEventStreamEventFlagItemFinderInfoMod");
        } else if (flag & kFSEventStreamEventFlagItemChangeOwner) {
            NSLog(@"kFSEventStreamEventFlagItemChangeOwner");
        } else if (flag & kFSEventStreamEventFlagItemXattrMod) {
            NSLog(@"kFSEventStreamEventFlagItemXattrMod");
        } else if (flag & kFSEventStreamEventFlagItemIsFile) {
            NSLog(@"kFSEventStreamEventFlagItemIsFile");
        } else if (flag & kFSEventStreamEventFlagItemIsDir) {
            NSLog(@"kFSEventStreamEventFlagItemIsDir");
        } else if (flag & kFSEventStreamEventFlagItemIsSymlink) {
            NSLog(@"kFSEventStreamEventFlagItemIsSymlink");
        } else {
            NSLog(@"i don't know!");
        }
    }
}

@implementation FileWatcher

- (instancetype)initWithWatchPath:(NSString *)watchPath {
    
    if (self = [super init]) {
        
        _watchPath = watchPath;
        _loop = NULL;
    }
    return self;
}

- (void)start {
    
    @autoreleasepool {
        
        if (!_watchPath) { return; }
        
        self.isExecuting = YES;
        self.isFinished = NO;
        
        CFStringRef watchDir = (__bridge CFStringRef)_watchPath;
        CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&watchDir, 1, NULL);
        
        FSEventStreamContext *fseventContext = (FSEventStreamContext *)malloc(sizeof(FSEventStreamContext));
        fseventContext->version = 0;
        fseventContext->info = (__bridge void *)(self);
        fseventContext->retain = NULL;
        fseventContext->release = NULL;
        fseventContext->copyDescription = NULL;
        
        FSEventStreamCreateFlags flags = kFSEventStreamCreateFlagNone |
                                         kFSEventStreamCreateFlagWatchRoot |
                                         kFSEventStreamEventFlagItemXattrMod |
                                         kFSEventStreamCreateFlagFileEvents;
        
        FSEventStreamRef stream = FSEventStreamCreate(NULL,
                                                      &watchCallback,
                                                      fseventContext,
                                                      pathsToWatch,
                                                      kFSEventStreamEventIdSinceNow,
                                                      1.0,
                                                      flags);
        
        _loop = CFRunLoopGetCurrent();
        FSEventStreamScheduleWithRunLoop(stream, _loop, kCFRunLoopDefaultMode);
        FSEventStreamStart(stream);
        
        CFRunLoopRun();
        
        FSEventStreamStop(stream);
        FSEventStreamInvalidate(stream);
        FSEventStreamRelease(stream);
        free(fseventContext);
        CFRelease(pathsToWatch);
        stream = NULL;
        fseventContext = NULL;
    }
}
- (void)cancel {
    
    [super cancel];
    if (_loop != NULL) {
        
        CFRunLoopStop(_loop);
        _loop = NULL;
    }
    
    self.isFinished = YES;
    self.isExecuting = NO;
}

- (void)setIsExecuting:(BOOL)isExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = isExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}


- (void)setIsFinished:(BOOL)isFinished {
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = isFinished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
