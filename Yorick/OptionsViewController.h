//
//  OptionsViewController.h
//  Yorick
//
//  Created by TerryTorres on 3/5/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "YorickStyle.h"
#import "TagSearchController.h"
#import "SettingsViewController.h"
#import "SizeControlViewController.h"
#import "PopUpView.h"
#import "TabBarController.h"

@interface OptionsViewController : UITableViewController

@property (weak, nonatomic) MonologueManager *manager;


@end
