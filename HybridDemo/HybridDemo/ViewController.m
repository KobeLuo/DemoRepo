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
@interface ViewController() {
    
    NSXPCConnection *_fileOperConnection;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialDir];
    
    _fileOperConnection = [[NSXPCConnection alloc] initWithServiceName:@"com.kobeluo.XPC.FileOperateServer"];
    _fileOperConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(FileOperation)];
    [_fileOperConnection resume];
}

- (void)initialDir {
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects:
                           NSURLNameKey,
                           NSURLFileSizeKey,
                           NSURLLocalizedTypeDescriptionKey,nil];
    
    NSString *rootpath = @"/Users/naver/Development/Research/HybridSync/HybridHost";
    NSString *virtualDir = [rootpath stringByAppendingString:@"Alias"];
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
            
            NSString *path = [virtualDir stringByAppendingPathComponent:name];
            [path createSparseFileWithApparentSize:fileSize.unsignedLongLongValue];
        }
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (IBAction)store:(id)sender {

    NSString *path = [@"/Users/naver/Development/Research/HybridSync/HybridHostAlias/Hybrid Demo Introduce.pages" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:path];
    
    [[_fileOperConnection remoteObjectProxy] operationWith:url reply:^(BOOL v) {
        
        NSLog(@"result:%d",v);
    }];
}
- (IBAction)free:(id)sender {
    
    NSString *path = [@"/Users/naver/Development/Research/HybridSync/HybridHostAlias/Hybrid Demo Introduce.pages" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    [[_fileOperConnection remoteObjectProxy] operationWith:url action:0 reply:^(BOOL v) {
        
        NSLog(@"result:%d",v);
    }];
}
@end

