//
//  HybridCore.m
//  HybridDemo
//
//  Created by Kobe on 2019/1/21.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "HybridCore.h"
#import "NSString+Extension.h"
#import "FilePresenter.h"
#import "FileOperateServer.h"
#import "ExtensionAttributes.h"

@interface HybridCore() {
    
    NSXPCConnection *_fileOperConnection;
    
    NSMutableArray *_presenters;
}

/// the route which was be mirrored.
@property (nonatomic, strong, readwrite) NSString *sourceRoute;

/// mirror route.
@property (nonatomic, strong, readwrite) NSString *mirrorRoute;

@end

@implementation HybridCore

- (instancetype)initWith:(NSString *)sourcePath mirror:(NSString *)mirrorRoute {
    
    if (self = [super init]) {
        
        self.sourceRoute = sourcePath;
        self.mirrorRoute = mirrorRoute;
        
        _fileOperConnection = [[NSXPCConnection alloc] initWithServiceName:@"com.kobeluo.XPC.FileOperateServer"];
        _fileOperConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(FileOperation)];
        _fileOperConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ForwardCall)];
        _fileOperConnection.exportedObject = self;
        [_fileOperConnection resume];
        
        _presenters = [NSMutableArray new];
        
        [self initialDir];
    }
    
    return self;
}

- (void)initialDir {
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects:
                           NSURLNameKey,
                           NSURLFileSizeKey,
                           NSURLLocalizedTypeDescriptionKey,nil];
    
    if (![NSFileManager.defaultManager fileExistsAtPath:self.mirrorRoute]) {
        
        [NSFileManager.defaultManager createDirectoryAtPath:self.mirrorRoute
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:NULL];
    }
    
    NSURL *url = [NSURL fileURLWithPath:self.sourceRoute];
    NSArray *list = [NSFileManager.defaultManager contentsOfDirectoryAtURL:url
                                                includingPropertiesForKeys:properties
                                                                   options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                     error:&error];
    
    [list enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *name = nil;
        [url getResourceValue:&name forKey:NSURLNameKey error:NULL];
        
        NSNumber *fileSize = nil;
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
        
        if (name && fileSize) {
            
            NSString *path = [self.mirrorRoute stringByAppendingPathComponent:name];
            [path createSparseFileWithApparentSize:fileSize.unsignedLongLongValue];

            [self startupMonitorWith:path];
            [path setXattrPlacehold:YES];
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

- (void)reMonitor:(NSString *)path {
    
    [self startupMonitorWith:path];
    
    [path setXattrPlacehold:YES];
}

- (void)downloadFileWith:(NSString *)path {
    
    NSURL *sourceUrl = [NSURL fileURLWithPath:[self.sourceRoute stringByAppendingPathComponent:path.lastPathComponent]];
    NSURL *destUrl = [NSURL fileURLWithPath:path];
    
    [[_fileOperConnection remoteObjectProxy] operationWith:sourceUrl
                                                      dest:destUrl
                                                    action:1
                                                     reply:^(BOOL v) {
        
        if (v) {
            
            NSLog(@"download success: %@",path);
            [path setXattrPlacehold:NO];
        }
    }];
}

- (void)clean {
    
    [_presenters removeAllObjects];
    _presenters = nil;
}
@end
