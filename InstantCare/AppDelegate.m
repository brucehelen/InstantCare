//
//  AppDelegate.m
//  InstantCare
//
//  Created by bruce-zhu on 15/11/27.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configIQKeyBoardManager];
    [self configSVHUD];
    [self configNavBarColor];

    return YES;
}

#pragma mark - 配置键盘样式
- (void)configIQKeyBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldShowTextFieldPlaceholder = YES;
    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
}

#pragma mark - 配置HUD
- (void)configSVHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

#pragma mark - 设置全局导航栏背景颜色
- (void)configNavBarColor
{
    // 背景灰色，文字白色
    UIColor *color = [UIColor colorWithRed:163.0/255.0 green:163/255.0 blue:163/255.0 alpha:1];
    [[UINavigationBar appearance] setBarTintColor:color];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
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

@end
