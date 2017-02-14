//
//  TabBarController.h
//  Yorick
//
//  Created by TerryTorres on 11/12/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "MonologueViewController.h"
#import "SettingsViewController.h"
#import "YorickStyle.h"

@interface TabBarController : UITabBarController <UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic) unsigned long indexOfNewTab;

- (void)hideTabBar;
- (void)showTabBar;

@end
