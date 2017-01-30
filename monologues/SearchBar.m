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
    self.barTintColor = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1.0];
}

@end
