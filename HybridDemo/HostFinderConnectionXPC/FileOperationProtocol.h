//
//  HostFinderConnectionXPCProtocol.h
//  HostFinderConnectionXPC
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileOperation

- (void)operationWith:(NSURL *)url reply:(void (^)(BOOL))reply;
- (void)operationWith:(NSURL *)url action:(int)act reply:(void (^)(BOOL))reply;

@end

/*
 To use the service from an application or other process, use NSXPCConnection to establish a connection to the service by doing something like this:

     _connectionToService = [[NSXPCConnection alloc] initWithServiceName:@"com.kobeluo.HostFinderConnectionXPC"];
     _connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HostFinderConnectionXPCProtocol)];
     [_connectionToService resume];

Once you have a connection to the service, you can use it like this:

     [[_connectionToService remoteObjectProxy] upperCaseString:@"hello" withReply:^(NSString *aString) {
         // We have received a response. Update our text field, but do it on the main thread.
         NSLog(@"Result string was: %@", aString);
     }];

 And, when you are finished with the service, clean up the connection like this:

     [_connectionToService invalidate];
*/
