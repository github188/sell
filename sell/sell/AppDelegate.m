//
//  AppDelegate.m
//  sell
//
//  Created by 韩冲 on 15/4/12.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *strPlistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:@"BuyList.plist"]; // 创建一个存放 BuyList.plist 的地址
    
    // 检查APP的沙盒内是否存在该文件 如果不存在，创建一个可编辑的字典（BuyList.plist文件）存入该地址
    if ([[NSFileManager defaultManager] fileExistsAtPath:strPlistPath] == NO) {
        [[NSMutableDictionary new] writeToFile:strPlistPath atomically:NO];
    }
    
    // 创建一个窗口 用来显示app的
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = SystemColor; // 背景颜色为系统绿（宏定义的，方便调用）
    
    LoginViewController *viewController = [LoginViewController new]; // 创建登录页
    viewController.automaticallyAdjustsScrollViewInsets = NO; // iOS7以上 防止自动移动20像素
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController]; // 创建一个存放页面的堆栈，控制页面跳转的  设置第一页为登录页
    
    [self.window setRootViewController:self.navigationController]; // 设置窗口的第一页为这个堆栈，也就是显示堆栈的最顶部的页面
    [self.window makeKeyAndVisible]; // 使窗口可用
    
    // window 这部分在iOS7之前是系统默认创建的
    
    return YES;
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
