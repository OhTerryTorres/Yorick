//
//  SearchBar.m
//  Yorick
//
//  Created by TerryTorres on 11/15/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [super awakeFromNib];
    self.translucent = YES;
    self.barTintColor = [YorickStyle color2];
}

@end
