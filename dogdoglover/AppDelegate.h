//
//  AppDelegate.h
//  dogdoglover
//
//  Created by katobit on 6/5/2557 BE.
//  Copyright (c) 2557 katobit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// Google Analytic //
@property(nonatomic, strong) id<GAITracker> tracker;
@end
