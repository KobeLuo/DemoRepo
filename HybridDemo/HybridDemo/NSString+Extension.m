//
//  NSString+Extension.m
//  HybridDemo
//
//  Created by Kobe on 2019/1/10.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "NSString+Extension.h"

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

@end
