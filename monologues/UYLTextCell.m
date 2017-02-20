//
//  UYLTextCell.m
//  Yorick
//
//  Created by TerryTorres on 7/7/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "UYLTextCell.h"

@implementation UYLTextCell

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
    [super awakeFromNib];
    
    self.cellTextLabel.font = [YorickStyle defaultFont];
    self.cellNotesLabel.font = [YorickStyle defaultFont];
    self.cellTagsLabel.font = [YorickStyle defaultFont];
    self.cellTitleLabel.font = [YorickStyle defaultFont];
    self.cellCharacterLabel.font = [YorickStyle defaultFontOfSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
