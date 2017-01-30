//
//  FilterTableViewCell.m
//  Yorick
//
//  Created by TerryTorres on 9/8/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (self.colored == YES ) {
        self.settingLabel.textColor = [UIColor colorWithRed:36.0/255.0 green:115.0/255.0 blue:119.0/255.0 alpha:0.6];
    } else if (self.colored == NO) {
        self.settingLabel.textColor = [UIColor grayColor];
    }
}



@end
