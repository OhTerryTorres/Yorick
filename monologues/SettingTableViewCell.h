//
//  FilterTableViewCell.h
//  Yorick
//
//  Created by TerryTorres on 9/8/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YorickStyle.h"

@interface SettingTableViewCell : UITableViewCell

@property (nonatomic) BOOL colored;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
