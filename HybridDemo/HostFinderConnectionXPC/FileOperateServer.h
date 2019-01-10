//
//  HostFinderConnectionXPC.h
//  HostFinderConnectionXPC
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileOperationProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface FileOperateServer : NSObject <FileOperation, NSXPCListenerDelegate>

@property (weak) NSXPCConnection *xpcConnection;

@end
