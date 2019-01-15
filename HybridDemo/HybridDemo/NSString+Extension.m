//
//  NSString+Extension.m
//  HybridDemo
//
//  Created by Kobe on 2019/1/10.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "NSString+Extension.h"
#import <sys/xattr.h>

@implementation NSString (Extension)

- (NSString *)runAsCommand {
    
    NSPipe *pipe = [NSPipe pipe];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    return [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}

- (BOOL)createSparseFileWithApparentSize:(unsigned long long)size {
    
    [[NSFileManager defaultManager] removeItemAtPath:self error:nil];
    createSparseFileUseFTruncate((char *)self.UTF8String, size);
    
    return YES;
}

int createSparseFileUseFTruncate(char *path, long long size) {
    
    int fd = -1;
    fd = open(path, O_RDWR | O_CREAT, 0666);
    if (fd < 0) {
        
        printf("ftruncate open failed\n");
        return -1;
    }
    
    if (ftruncate(fd, size)) {
        
        printf("ftruncate file error \n");
        return -1;
    }
    
    close(fd);
    return 0;
}


#define placeholderKey @"attributes.extern.placeholder.for.filesystem"

- (void)setXattrPlacehold:(BOOL)placeholder {
    
    const char *cpath = [self cStringUsingEncoding:NSUTF8StringEncoding];
    if (placeholder) {
        
        
        int rc = setxattr(cpath, placeholderKey.UTF8String, &placeholder, sizeof(placeholder), 0, 0);
        if (rc) {
            NSLog(@"placeholder extension set error for path:%@",self);
        }
    }else {
        
        removexattr(cpath, placeholderKey.UTF8String, 0);
    }
}

- (BOOL)isPlaceholder {
    
    const char *cpath = [self cStringUsingEncoding:NSUTF8StringEncoding];
    ssize_t len = getxattr(cpath, placeholderKey.UTF8String, NULL, 0, 0, 0);
    if (len < 0) {
        
        NSLog(@"get placeholder extension error for path:%@",self);
        return NO;
    }
    return len;
    
    //    const char *attrName = [attribute UTF8String];
    //    const char *filePath = [_path fileSystemRepresentation];
    //
    //    // get size of needed buffer
    //    int bufferLength = getxattr(filePath, attrName, NULL, 0, 0, 0);
    //
    //    // make a buffer of sufficient length
    //    char *buffer = malloc(bufferLength);
    //
    //    // now actually get the attribute string
    //    getxattr(filePath, attrName, buffer, 255, 0, 0);
    //
    //    // convert to NSString
    //    NSString *retString = [[NSString alloc] initWithBytes:buffer length:bufferLength encoding:NSUTF8StringEncoding];
    //
    //    // release buffer
    //    free(buffer);
}


@end
