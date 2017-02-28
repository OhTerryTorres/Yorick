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
    [super awakeFromNib];
    
    self.titleLabel.font = [YorickStyle defaultFontBoldOfSize:20];
    self.characterLabel.font = [YorickStyle defaultFontOfSize:14];
    self.excerptLabel.font = [YorickStyle defaultFontOfSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark: Format Excerpt Label

-(void)setExcerptLabelWithString:(NSString*)string {
    string = [string stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"\n\n" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

    NSUInteger length = [string length];
    if (length > 300) { length = 300; };
    // define the range you're interested in
    NSRange stringRange = {0, MIN([string length], length)};
    // adjust the range to include dependent chars
    stringRange = [string rangeOfComposedCharacterSequencesForRange:stringRange];
    // Now you can create the short string
    string = [string substringWithRange:stringRange];
    
    self.excerptLabel.text = string;
}

@end
