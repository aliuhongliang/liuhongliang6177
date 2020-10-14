//
//  AppDelegate.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/13.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    HomeViewController *vc = [[HomeViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
