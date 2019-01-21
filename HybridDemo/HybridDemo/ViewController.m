//
//  ViewController.m
//  HybridSyncDemo
//
//  Created by Kobe on 2019/1/9.
//  Copyright © 2019 Kobe. All rights reserved.
//

#import "ViewController.h"
#import "FileWatcher.h"
#import "HybridCore.h"
@interface ViewController() {
    
    NSString *_resourcePath;
    NSString *_mirrorPath;
    
    NSOperationQueue *_queue;
    NSString *_watchPath;
    
    HybridCore *_hcore;
    
    NSButton *_mirrorSender;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createFileWatch {
    
    _queue = [NSOperationQueue new];
    
    FileWatcher *watcher = [[FileWatcher alloc] initWithWatchPath:_watchPath];
    [_queue addOperation:watcher];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (IBAction)store:(id)sender {
    
    if (nil != _watchPath) {
        
        [self createFileWatch];
    }
}
- (IBAction)free:(id)sender {
    
    if (!_mirrorSender) { return; }
    
    /// 1.reset the mirror button's title.
    NSString *desc = @"Please selected one empty folder to mirror";
    [_mirrorSender setTitle:desc];
    
    /// 2.clean the mirror route.
    [_hcore clean];
    _hcore = nil;
    
    /// 3.delete the mirror directory.
    [[NSFileManager defaultManager] removeItemAtPath:_mirrorPath error:nil];
    
    /// 4.reset the mirror sender.
    _mirrorSender = nil;
}



- (void)messageDidCall:(NSString *)info reply:(void (^)(BOOL value))reply {
    
    NSLog(@"info :%@",info);
}

- (IBAction)resourceRoute:(NSButton *)sender {
    
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    panel.resolvesAliases = NO;
    panel.canChooseFiles = NO;
    panel.canChooseDirectories = YES;
    panel.canCreateDirectories = NO;
    panel.allowsMultipleSelection = NO;
    
    NSInteger result = [panel runModal];
    
    if (NSModalResponseOK == result) {
        
        _resourcePath = panel.URL.path;
    }

    [sender setTitle:_resourcePath];
}

- (IBAction)mirrorDest:(NSButton *)sender {
    
    _mirrorSender = sender;
    
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    panel.resolvesAliases = NO;
    panel.canChooseFiles = NO;
    panel.canChooseDirectories = YES;
    panel.canCreateDirectories = YES;
    panel.allowsMultipleSelection = NO;
    
    NSInteger result = [panel runModal];
    
    if (NSModalResponseOK == result) {
        
        [self free:nil];
        
        _mirrorPath = panel.URL.path;
        _watchPath = _mirrorPath;
        [sender setTitle:_mirrorPath];
        
        [self loadHybridCore];
        
        NSURL *url = [NSURL fileURLWithPath:_mirrorPath];
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]];
    }
}

- (void)loadHybridCore {
    
    if (!_resourcePath || !_mirrorPath) { return; }
    
    _hcore = [[HybridCore alloc] initWith:_resourcePath mirror:_mirrorPath];
}


@end

