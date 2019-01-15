//
//  ViewController.m
//  HybridSyncDemo
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "ViewController.h"
#import "FileOperateServer.h"
#import "NSString+Extension.h"
#import "FileWatcher.h"
#import "FilePresenter.h"
#import "ExtensionAttributes.h"
@interface ViewController() {
    
    NSXPCConnection *_fileOperConnection;
    
    NSOperationQueue *_queue;
    
    NSString *_watchPath;
    
    NSMutableArray *_presenters;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialDir];
    
    _fileOperConnection = [[NSXPCConnection alloc] initWithServiceName:@"com.kobeluo.XPC.FileOperateServer"];
    _fileOperConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(FileOperation)];
    _fileOperConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ForwardCall)];
    _fileOperConnection.exportedObject = self;
    [_fileOperConnection resume];
    
//    [self createFileWatch];
    _presenters = [NSMutableArray new];
}

- (void)createFileWatch {
    
    _queue = [NSOperationQueue new];
    
    FileWatcher *watcher = [[FileWatcher alloc] initWithWatchPath:_watchPath];
    [_queue addOperation:watcher];
}


- (void)initialDir {
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects:
                           NSURLNameKey,
                           NSURLFileSizeKey,
                           NSURLLocalizedTypeDescriptionKey,nil];
    
    NSString *rootpath = @"/Users/naver/Development/Research/HybridSync/HybridHost";
    NSString *virtualDir = [rootpath stringByAppendingString:@"Alias"];
    _watchPath = virtualDir;
    
    if (![NSFileManager.defaultManager fileExistsAtPath:virtualDir]) {
        
        [NSFileManager.defaultManager createDirectoryAtPath:virtualDir withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSURL *url = [NSURL fileURLWithPath:rootpath];
    NSArray *list = [NSFileManager.defaultManager contentsOfDirectoryAtURL:url
                                                includingPropertiesForKeys:properties options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    
    [list enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *name = nil;
        [url getResourceValue:&name forKey:NSURLNameKey error:NULL];
        
        NSNumber *fileSize = nil;
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
        
        if (name && fileSize) {
            
            NSString *path = [(NSString *)virtualDir stringByAppendingPathComponent:name];
            [path createSparseFileWithApparentSize:fileSize.unsignedLongLongValue];
            
            [path setXattrPlacehold:YES];
            
            [self startupMonitorWith:path];
        }
    }];
}

- (void)startupMonitorWith:(NSString *)path {
    
    NSURL *url = [NSURL fileURLWithPath:path];
    FilePresenter *presenter = [[FilePresenter alloc] initWithUrl:url];
    
    __weak typeof(self) weakself = self;
    
    [presenter observeFileNeedDownload:^(NSString * _Nonnull path) {
        
        [weakself downloadFileWith:path];
    }];
    
    [_presenters addObject:presenter];
}

- (void)downloadFileWith:(NSString *)path {
    
    NSURL *url = [NSURL fileURLWithPath:path];
    [[_fileOperConnection remoteObjectProxy] operationWith:url reply:^(BOOL v) {
        
        if (v) {
            
            NSLog(@"download success: %@",path);
            [path setXattrPlacehold:NO];
        }
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (IBAction)store:(id)sender {

    NSString *path = @"/Users/naver/Development/Research/HybridSync/HybridHostAlias/chinaPermit_9.pdf";
    [self startupMonitorWith:path];
    [path setXattrPlacehold:YES];
//    [[_fileOperConnection remoteObjectProxy] operationreply:^(BOOL v) {
//
//        NSLog(@"result:%d",v);
//    }];
}
- (IBAction)free:(id)sender {
    
//    NSString *path = [@"/Users/naver/Development/Research/HybridSync/HybridHostAlias/Hybrid Demo Introduce.pages" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSURL *url = [NSURL fileURLWithPath:path];
//
//    [[_fileOperConnection remoteObjectProxy] operationWith:url action:0 reply:^(BOOL v) {
//
//        NSLog(@"result:%d",v);
//    }];
}



- (void)messageDidCall:(NSString *)info reply:(void (^)(BOOL value))reply {
    
    NSLog(@"info :%@",info);
}

@end

