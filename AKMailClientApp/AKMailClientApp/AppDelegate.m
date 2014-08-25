//
//  AppDelegate.m
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AppDelegate.h"
#import "AKMailListViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        // Override point for customization after application launch.
    UISplitViewController *splitViewController   = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
        //Saves changes in the application's managed object context before the application terminates.
        //[self saveContext];
    [[AKModel sharedManager].dataSource saveContext];
}

@end
