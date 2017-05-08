//
//  AppDelegate.m
//  takadaApp
//
//  Created by  on 08/05/2017.
//  Copyright © 2017 lzy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeInterface];
    return YES;
}

#pragma mark -
#pragma mark 全局外观设置
#pragma mark
- (void)customizeInterface
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //导航栏
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [navigationBarAppearance setBarTintColor:[AppColor naviBarBarTintColor]];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    [navigationBarAppearance setBackgroundColor:[AppColor naviBarBarTintColor]];
    navigationBarAppearance.translucent = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64)
                                                         forBarMetrics:UIBarMetricsDefault];

    //tab栏
    UITabBar *tabBar =[UITabBar appearance];
    [tabBar setTintColor:[AppColor cherryColor]];

    [[UITabBarItem appearance] setTitleTextAttributes: @{
                                                         NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                                         }
                                             forState: UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes: @{
                                                         NSForegroundColorAttributeName:[AppColor cherryColor]
                                                         }
                                             forState: UIControlStateSelected];
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
