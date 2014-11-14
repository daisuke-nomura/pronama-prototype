//
//  AppDelegate.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSString *twtHashTag;}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger count;
@property (strong, nonatomic) UITabBarController *tabBar;
@property (nonatomic, assign) NSString *twtHashTag;

@property BOOL firstFeedList;
@end
