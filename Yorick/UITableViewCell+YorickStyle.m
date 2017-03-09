//
//  UITableViewCell+YorickStyle.m
//  Yorick
//
//  Created by TerryTorres on 2/20/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "UITableViewCell+YorickStyle.h"

@implementation UITableViewCell (YorickStyle)

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.textLabel.font = [YorickStyle defaultFont];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

@end
