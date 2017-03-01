//
//  UILabel+YorickStyle.m
//  Yorick
//
//  Created by TerryTorres on 2/20/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "UILabel+YorickStyle.h"

@implementation UILabel (YorickStyle)


- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [YorickStyle defaultFont];
}

@end
