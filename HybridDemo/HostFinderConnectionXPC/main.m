//
//  main.m
//  HostFinderConnectionXPC
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileOperationProtocol.h"
#import "FileOperateServer.h"

int main(int argc, const char *argv[])
{
    // Create the delegate for the service.
    FileOperateServer *delegate = [FileOperateServer new];
    
    // Set up the one NSXPCListener for this service. It will handle all incoming connections.
    NSXPCListener *listener = [NSXPCListener serviceListener];
    listener.delegate = delegate;
    
    // Resuming the serviceListener starts this service. This method does not return.
    [listener resume];
    return 0;
}
