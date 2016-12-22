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

@interface SettingsViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) Setting *genderSetting;
@property (strong, nonatomic) Setting *toneSetting;
@property (strong, nonatomic) Setting *periodSetting;
@property (strong, nonatomic) Setting *ageSetting;
@property (strong, nonatomic) Setting *lengthSetting;

@property (strong, nonatomic) Setting *sizeSetting;
@property (strong, nonatomic) Setting *sortSetting;

@property (strong, nonatomic) NSMutableArray *settingsArray;

@property (nonatomic) UIView *layer;

- (IBAction)clearSettings:(id)sender;



@end
