//
//  AppDelegate.m
//  TestKeplerDemo
//
//  Created by Lemon on 16/1/20.
//  Copyright © 2016年 jd. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <JDKeplerSDK/KeplerApiManager.h>

#define Value_AppKey @"7DA9CEF6540029AA95E09135D3AB4AED"
#define Value_AppSecret @"e74f246c3bee44b5b968a5326614f402"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[KeplerApiManager sharedKPService]asyncInitSdk:Value_AppKey secretKey:Value_AppSecret sucessCallback:^(){
        
    }failedCallback:^(NSError *error){
        
    }];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *rootVC = [[ViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [_window setRootViewController:navigation];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2){
    return [[KeplerApiManager sharedKPService] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//iOS7以后会根据获取的结果适当的调整唤醒的时间策略
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"%s",__FUNCTION__);
    BOOL haveJDKeplerServiceNewContent = NO;
    [self fetchJDKeplerService:&haveJDKeplerServiceNewContent];
    if (haveJDKeplerServiceNewContent){
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)fetchJDKeplerService:(BOOL *)paramFetchedJDKeplerNewContent {
    
    [[KeplerApiManager sharedKPService] checkJDKeplerUpdate]; //检测更新
}

@end
