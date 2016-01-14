//
//  AppDelegate.m
//  HappyWeekend
//
//  Created by 张茫原 on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboSDK.h"

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    
    //UITabbarController
    self.tabBarVC = [[UITabBarController alloc] init];
    
    //创建被tabBarVC管理的视图控制器
    
    //主页
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainStoryBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    UIImage *mainSelectImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    //tabbar设置选中图片按照图片原始状态显示
    mainNav.tabBarItem.selectedImage = [mainSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //调整tabBar图片显示位置:按照上、左、下、右的顺序设置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //发现
    UIStoryboard *discoverStotyBoard = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverStotyBoard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
    UIImage *discoverSelectImage = [UIImage imageNamed:@"ft_found_selected_ic"];
    //tabbar设置选中图片按照图片原始状态显示
    discoverNav.tabBarItem.selectedImage = [discoverSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //我的
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *mineNav = mineStoryBoard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    UIImage *mineSelectImage = [UIImage imageNamed:@"ft_person_selected_ic"];
    //tabbar设置选中图片按照图片原始状态显示
    mineNav.tabBarItem.selectedImage = [mineSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    //添加被管理的视图控制器
    self.tabBarVC.viewControllers = @[mainNav,discoverNav,mineNav];
    self.tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark  -------  Share WeiboSDK

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        //发送成功
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareToSinaWeibo" object:nil userInfo:nil];
    }
    
//    if ([response isKindOfClass:[WBProvideMessageForWeiboResponse class]]) {
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@", (int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//    } else if ([response isKindOfClass:WBAuthorizeResponse.class])
//    {
//        
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        
//        [alert show];
//    }
    
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











