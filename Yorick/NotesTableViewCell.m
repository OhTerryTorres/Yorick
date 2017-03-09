//
//  NotesTableViewCell.m
//  Yorick
//
//  Created by TerryTorres on 2/20/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "NotesTableViewCell.h"

@implementation NotesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = [YorickStyle defaultFont];
    self.titleLabel.textColor = [UIColor grayColor];
    self.characterLabel.font = [YorickStyle defaultFontOfSize:14];
    self.characterLabel.textColor = [UIColor grayColor];
    self.notesLabel.font = [YorickStyle defaultFont];
    self.notesLabel.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
