//
//  AppDelegate.m
//  dogdoglover
//
//  Created by katobit on 6/5/2557 BE.
//  Copyright (c) 2557 katobit. All rights reserved.
//

#import "AppDelegate.h"
#import "mainView_iphone.h"
#import "mainView_ipad.h"

// Google Analytic SDK .//
#import "GAIDictionaryBuilder.h"
//////////////////

@implementation AppDelegate

// Google Analitic
//static NSString *const kGoogleAnalytic =  @"UA-18384901-14";
/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-40209680-3";
static NSString *const kAllowTracking = @"allowTracking";
/////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"DogdogLover"
                                              trackingId:kTrackingId];
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        mainView_iphone *test = [[mainView_iphone alloc]     initWithNibName:@"mainView_iphone" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]  initWithRootViewController:test];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        return YES;
    }
    else
    {
        mainView_ipad *test = [[mainView_ipad alloc]     initWithNibName:@"mainView_ipad" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]  initWithRootViewController:test];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        return YES;
    }
    
    

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
