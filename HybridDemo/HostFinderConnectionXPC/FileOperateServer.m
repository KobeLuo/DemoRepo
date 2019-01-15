//
//  HostFinderConnectionXPC.m
//  HostFinderConnectionXPC
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "FileOperateServer.h"
#import "NSString+Extension.h"

@interface FileOperateServer() {
    
    NSXPCListener *_listener;
}

@end

@implementation FileOperateServer
#pragma mark - XPC Listener Delegate
- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    
    _listener = listener;
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(FileOperation)];
    newConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ForwardCall)];
    newConnection.exportedObject = self;
    self.xpcConnection = newConnection;
    
    [self.xpcConnection resume];
    
    return YES;
}

#pragma mark - XPC Interface Delegate
- (void)operationWith:(NSURL *)url action:(int)act reply:(void (^)(BOOL))reply {
    
    NSLog(@"%@",_listener);
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
        
        NSString *dest = url.path;
        [dest setXattrPlacehold:YES];
    }
    
    if (reply) {
        
        reply(YES);
    }
}

- (void)operationreply:(void (^)(BOOL))reply {
    
    NSLog(@"received");
    
    [[_xpcConnection remoteObjectProxy] messageDidCall:@"123" reply:^(BOOL v) {
        
        NSLog(@"s");
    }];
    
    if (reply) {
        
        reply(YES);
    }
}

- (void)operationWith:(NSURL *)url reply:(void (^)(BOOL))reply {
    
    [self operationWith:url action:1 reply:reply];
}

@end
