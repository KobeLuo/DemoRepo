//
//  FilePresenter.m
//  HybridDemo
//
//  Created by Kobe on 2019/1/15.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "FilePresenter.h"
#import "NSString+Extension.h"
@interface FilePresenter() {
    
    FPDownloadInvoke _invoke;
}
@property (nonatomic, retain) NSURL *url;
@end

@implementation FilePresenter

- (instancetype)initWithUrl:(NSURL *)url {
    
    if (self = [super init]) {
        
        self.url = url;
        [NSFileCoordinator addFilePresenter:self];
    }
    return self;
}

- (void)dealloc {
    
    [NSFileCoordinator removeFilePresenter:self];
    _url = nil;
}

- (NSURL *)presentedItemURL { return _url; }

- (NSOperationQueue *)presentedItemOperationQueue { return [NSOperationQueue mainQueue]; }

- (void)observeFileNeedDownload:(FPDownloadInvoke)invoke {
    
    _invoke = invoke;
}

- (void)relinquishPresentedItemToReader:(void (^)(void (^ _Nullable)(void)))reader {
    
    if ([self.url.path isPlaceholder] && _invoke) {
        
        _invoke(self.url.path);
    }
    
    reader(^{});
}

- (void)relinquishPresentedItemToWriter:(void (^)(void (^ _Nullable)(void)))writer {
    
    NSLog(@"2");
    
    writer(^{});
}
@end
