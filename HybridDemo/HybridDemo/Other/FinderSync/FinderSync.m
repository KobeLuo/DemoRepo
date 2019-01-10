//
//  FinderSync.m
//  HybridFinderSync
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "FinderSync.h"
#import "FileOperateServer.h"
@interface FinderSync () {
    
    NSArray *_selectedItems;
    NSXPCConnection *_fileOperConnection;
}

@property NSURL *myFolderURL;

@end

@implementation FinderSync

- (instancetype)init {
    
    self = [super init];
    NSLog(@"%s launched from %@ ; compiled at %s", __PRETTY_FUNCTION__, [[NSBundle mainBundle] bundlePath], __TIME__);
    
    NSString *rootpath = @"/Users/naver/Development/Research/HybridSync/HybridHostAlias";
    // Set up the directory we are syncing.
    self.myFolderURL = [NSURL fileURLWithPath:rootpath];
    [FIFinderSyncController defaultController].directoryURLs = [NSSet setWithObject:self.myFolderURL];
    
    _fileOperConnection = [[NSXPCConnection alloc] initWithServiceName:@"com.kobeluo.XPC.FileOperateServer"];
    _fileOperConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(FileOperation)];
    [_fileOperConnection resume];
    
    return self;
}

#pragma mark - Primary Finder Sync protocol methods

- (void)beginObservingDirectoryAtURL:(NSURL *)url {
    // The user is now seeing the container's contents.
    // If they see it in more than one view at a time, we're only told once.
    NSLog(@"beginObservingDirectoryAtURL:%@", url.filePathURL);
}


- (void)endObservingDirectoryAtURL:(NSURL *)url {
    // The user is no longer seeing the container's contents.
    NSLog(@"endObservingDirectoryAtURL:%@", url.filePathURL);
}

- (void)requestBadgeIdentifierForURL:(NSURL *)url {
    //    NSLog(@"requestBadgeIdentifierForURL:%@", url.filePathURL);
    //
    //    // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.
    //    NSInteger whichBadge = [url.filePathURL hash] % 3;
    //    NSString* badgeIdentifier = @[@"", @"One", @"Two"][whichBadge];
    //    [[FIFinderSyncController defaultController] setBadgeIdentifier:badgeIdentifier forURL:url];
}

#pragma mark - Menu and toolbar item support

- (NSString *)toolbarItemName {
    return @"HybridFinderSync";
}

- (NSString *)toolbarItemToolTip {
    return @"HybridFinderSync: Click the toolbar item for a menu.";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameCaution];
}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu {
    // Produce a menu for the extension.
    
    if (whichMenu != FIMenuKindContextualMenuForItems) {
        return nil;
    }
    
    _selectedItems = [FIFinderSyncController.defaultController selectedItemURLs];
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    
    NSMenuItem *subMenu = [[NSMenuItem alloc] initWithTitle:@"Store aways" action:@selector(store:) keyEquivalent:@""];
    [menu addItem:subMenu];
    
    NSMenuItem *subMenu1 = [[NSMenuItem alloc] initWithTitle:@"Free space" action:@selector(free:) keyEquivalent:@""];
    [menu addItem:subMenu1];
    return menu;
}


- (void)store:(NSMenuItem *)o {

    [_selectedItems enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [[self->_fileOperConnection remoteObjectProxy] operationWith:url action:1 reply:^(BOOL result) {
            
            NSLog(@"store success");
        }];
    }];
}

- (void)free:(NSMenuItem *)o {
    
    [_selectedItems enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [[self->_fileOperConnection remoteObjectProxy] operationWith:url action:0 reply:^(BOOL result) {
            
            NSLog(@"free success");
        }];
    }];
}

- (IBAction)sampleAction:(id)sender {
    NSURL* target = [[FIFinderSyncController defaultController] targetedURL];
    NSArray* items = [[FIFinderSyncController defaultController] selectedItemURLs];
    
    NSLog(@"sampleAction: menu item: %@, target = %@, items = ", [sender title], [target filePathURL]);
    [items enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"    %@", [obj filePathURL]);
    }];
}

@end


