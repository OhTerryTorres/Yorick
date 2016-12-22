//
//  MonologueTableViewCell.m
//  Yorick
//
//  Created by TerryTorres on 3/18/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "MonologueTableViewCell.h"

@implementation MonologueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
