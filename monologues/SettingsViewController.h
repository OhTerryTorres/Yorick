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
#import "TagSettingDataService.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) MonologueManager *manager;
@property (strong, nonatomic) IBOutlet UITableView *tagsTable;
@property (strong, nonatomic) IBOutlet UITableView *settingTable;


- (IBAction)clearSettings:(id)sender;


@end
