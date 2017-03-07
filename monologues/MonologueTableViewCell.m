//
//  MonologueTableViewCell.m
//  Yorick
//
//  Created by TerryTorres on 3/18/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "MonologueTableViewCell.h"

@implementation MonologueTableViewCell

-(void)setStyle {
    self.titleLabel.font = [YorickStyle defaultFontOfSize:19];
    self.characterLabel.font = [YorickStyle defaultFontOfSize:14];
    self.excerptLabel.font = [YorickStyle defaultFontOfSize:16];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    [self setStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark: Format Excerpt Label

-(void)setExcerptLabelWithString:(NSString*)string {
    // Remove text in brackets
    while([string rangeOfString:@"["].location != NSNotFound && [string rangeOfString:@"]"].location != NSNotFound) {
        NSRange start = [string rangeOfString:@"["];
        NSRange end = [string rangeOfString:@"]"];
        NSRange completeRange = NSMakeRange(start.location, (end.location - start.location + 1));
        if (start.location != NSNotFound && end.location != NSNotFound && end.location > start.location) {
            NSString *betweenBraces = [string substringWithRange:completeRange];
            string = [string stringByReplacingOccurrencesOfString:betweenBraces withString:@""];
        }
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"\n\n" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"  " withString:@" "];

    NSUInteger length = [string length];
    if (length > 300) { length = 300; };
    // define the range you're interested in
    NSRange stringRange = {0, MIN([string length], length)};
    // adjust the range to include dependent chars
    stringRange = [string rangeOfComposedCharacterSequencesForRange:stringRange];
    // Now you can create the short string
    string = [string substringWithRange:stringRange];
    
    self.excerptLabel.text = string;

    [self setStyle];
}

@end
