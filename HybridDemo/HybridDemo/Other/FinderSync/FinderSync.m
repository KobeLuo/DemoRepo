//
//  FinderSync.m
//  HybridFinderSync
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "FinderSync.h"

@interface FinderSync () {
    
    NSArray *_selectedItems;
}

@property NSURL *myFolderURL;

@end

@implementation FinderSync

- (instancetype)init {
    
    self = [super init];
    NSLog(@"%s launched from %@ ; compiled at %s", __PRETTY_FUNCTION__, [[NSBundle mainBundle] bundlePath], __TIME__);
    
    NSString *rootpath = nil;
#if HYBRID
    rootpath = @"/Users/naver/Development/Research/HybridSync/HybridHostAlias";
#endif
    // Set up the directory we are syncing.
    self.myFolderURL = [NSURL fileURLWithPath:rootpath];
    [FIFinderSyncController defaultController].directoryURLs = [NSSet setWithObject:self.myFolderURL];
    
    // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf images.
    //    [[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameColorPanel] label:@"Status One" forBadgeIdentifier:@"One"];
    //    [[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameCaution] label:@"Status Two" forBadgeIdentifier:@"Two"];
    
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
    
    for (NSURL *url in _selectedItems) {
        
        NSString *dest = url.path;
        NSString *name = dest.lastPathComponent;
        NSString *source = [dest.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent stringByAppendingFormat:@"/HybridHost/%@",name];
        
        NSError *err = nil;
        [NSFileManager.defaultManager removeItemAtPath:dest error:&err];
        if (err) {
            
            NSLog(@"%@",err);
        }
        //        [NSFileManager.defaultManager removeItemAtURL:url error:NULL];
        //        [[NSFileManager defaultManager] copyItemAtPath:source toPath:dest error:NULL];
    }
}

- (void)free:(NSMenuItem *)o {
    
    for (NSURL *url in _selectedItems) {
        
        NSString *dest = url.path;
        NSString *name = dest.lastPathComponent;
        NSString *source = [dest.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent stringByAppendingFormat:@"HybridHost/%@",name];
        
        [[NSFileManager defaultManager] copyItemAtPath:source toPath:dest error:NULL];
    }
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


