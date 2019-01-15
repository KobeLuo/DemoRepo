//
//  FilePresenter.h
//  HybridDemo
//
//  Created by Kobe on 2019/1/15.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FPDownloadInvoke)(NSString *path);

@interface FilePresenter : NSObject <NSFilePresenter>

@property (readonly, copy) NSURL *presentedItemURL;

- (instancetype)initWithUrl:(NSURL *)url;
- (void)observeFileNeedDownload:(FPDownloadInvoke)invoke;
@end

NS_ASSUME_NONNULL_END
