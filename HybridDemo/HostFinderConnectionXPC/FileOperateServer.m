//
//  HostFinderConnectionXPC.m
//  HostFinderConnectionXPC
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "FileOperateServer.h"
#import "NSString+Extension.h"

@implementation FileOperateServer
#pragma mark - XPC Listener Delegate
- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(FileOperation)];
    
    newConnection.exportedObject = self;
//    newConnection.remoteObjectInterface
    self.xpcConnection = newConnection;
    
    [self.xpcConnection resume];
    
    return YES;
}

#pragma mark - XPC Interface Delegate
- (void)operationWith:(NSURL *)url action:(int)act reply:(void (^)(BOOL))reply {
    
    // store aways if act equal 1， otherwise free space.
    if (act == 1) {
        
        NSString *dest = url.path;
        NSString *name = dest.lastPathComponent;
        NSString *source = [dest.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent stringByAppendingFormat:@"/HybridHost/%@",name];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:url.path error:&error];
        if (error) {
            
            NSLog(@"remove file error: %@",error.localizedDescription);
        }
        
        [[NSFileManager defaultManager] copyItemAtPath:source toPath:dest error:&error];
        
        if (error) {
            
            NSLog(@"copy file error: %@",error.localizedDescription);
        }
    }else {
        
        unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil] fileSize];
        [url.path createSparseFileWithApparentSize:size];
    }
    
    if (reply) {
        
        reply(YES);
    }
}

- (void)operationWith:(NSURL *)url reply:(void (^)(BOOL))reply {
    
    [self operationWith:url action:1 reply:reply];
}

@end
