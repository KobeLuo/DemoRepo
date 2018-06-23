//
//  AppDelegate.m
//  UICollectionViewDemo
//
//  Created by KobeLuo on 6/19/18.
//  Copyright © 2018 KobeLuo. All rights reserved.
//

#import "AppDelegate.h"
#import <Photos/Photos.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
	// Override point for customization after application launch.
	
	// 获取所有资源的集合，并按资源的创建时间排序
//	PHFetchOptions *options = [[PHFetchOptions alloc] init];
//	options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//	PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
//	// 这时 assetsFetchResults 中包含的，应该就是各个资源（PHAsset）
//	for (NSInteger i = 0; i < assetsFetchResults.count; i++) {
//		// 获取一个资源（PHAsset）
//		PHAsset *asset = assetsFetchResults[i];
//		NSLog(@"%@",asset);
//	}
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
