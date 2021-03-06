//
//  SettingsViewController.h
//  Yorick
//
//  Created by TerryTorres on 3/17/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"
#import "SettingTableViewCell.h"
#import "AppDelegate.h"
#import "YorickStyle.h"
#import "TagSearchController.h"
#import "PopUpView.h"
#import "TabBarController.h"

@interface SettingsViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) MonologueManager *manager;


- (IBAction)clearSettings:(id)sender;


@end
