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
        self.settingLabel.textColor = [YorickStyle color2];
    } else if (self.colored == NO) {
        self.settingLabel.textColor = [UIColor grayColor];
    }
}



@end
