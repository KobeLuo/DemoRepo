//
//  ViewController.m
//  HybridSyncDemo
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialDir];
    
    //    createSparseFileUseFTruncate();
    //    createSparseFileUseFAllocate();
}

- (void)initialDir {
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects:
                           NSURLLocalizedNameKey,
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
        
        NSString *localizedName = nil;
        [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
        
        NSNumber *fileSize = nil;
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
        
        if (localizedName && fileSize) {
            
            char *path = (char *)[virtualDir stringByAppendingPathComponent:localizedName].UTF8String;
            createSparseFileUseFTruncate(path, [fileSize integerValue]);
        }
    }];
}

- (void)createSparseFileUseDDCommand {}

uint64_t file_size = 10 * 1024ULL;

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
    //    lseek(fd, file_size - 1, SEEK_CUR);
    //    write(fd, "N", 1);
    
    close(fd);
    return 0;
}

int createSparseFileUseFAllocate() {
    
    int fd = -1;
    int ret = -1;
    
    fd = open("/Users/naver/Desktop/fallcate.txt",O_RDWR | O_CREAT, 0666);
    if (fd < 0) {
        
        printf("fallcate open failed");
        return -1;
    }
    
    fstore_t store = {F_ALLOCATECONTIG,F_PEOFPOSMODE,0,file_size};
    ret = fcntl(fd, F_PREALLOCATE,&store);
    if (ret < 0) {
        
        printf("fcntl prealloc failed");
        return -1;
    }
    
    ret = ftruncate(fd, file_size);
    
    close(fd);
    return 0;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}


@end

