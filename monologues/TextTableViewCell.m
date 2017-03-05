//
//  TextTableViewCell.m
//  Yorick
//
//  Created by TerryTorres on 2/21/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "TextTableViewCell.h"

@implementation TextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    self.monologueTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.monologueTextLabel.frame);
}

@end
