//
//  TabBarController.h
//  Yorick
//
//  Created by TerryTorres on 11/12/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "BrowseViewController.h"
#import "FavoritesViewController.h"
#import "SettingsViewController.h"

@interface TabBarController : UITabBarController <UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic) unsigned long indexOfNewTab;

@end
