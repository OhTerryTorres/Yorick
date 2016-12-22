//
//  ResizeLabel.m
//  Yorick
//
//  Created by TerryTorres on 4/28/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "ResizeLabel.h"

@implementation ResizeLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    NSLog(@"BOUNDS");
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end
