//
//  AppDelegate.m
//  BlocQuery
//
//  Created by Melissa Boring on 12/6/15.
//  Copyright © 2015 melbo. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"Gymx0tmbAzgrfhtycAOa4yj3zjvK0Nmo2XA5miNu"
                  clientKey:@"NyELiHuZXBDftIGpNANCVRSA8lsrVo1i3x0Z6fzk"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *navigationVC = [[UINavigationController alloc]init];
    self.window.rootViewController = navigationVC;

    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    [navigationVC pushViewController:loginVC animated:NO];
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end
