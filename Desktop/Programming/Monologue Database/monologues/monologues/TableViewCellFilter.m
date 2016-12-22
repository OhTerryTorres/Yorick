//
//  FilterTableViewCell.m
//  monologues
//
//  Created by TerryTorres on 9/8/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "TableViewCellFilter.h"

@implementation TableViewCellFilter



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (self.colored == YES ) {
        self.detailTextLabel.textColor = [UIColor colorWithRed:36.0/255.0 green:115.0/255.0 blue:119.0/255.0 alpha:0.6];
    } else if (self.colored == NO) {
        self.detailTextLabel.textColor = [UIColor grayColor];
    }
}



@end
