//
//  Setting.m
//  Yorick
//
//  Created by TerryTorres on 3/17/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "Setting.h"

@implementation Setting

-(id)init {
    return self;
}

-(id)initWithTitle:(NSString*)title {
    self = [super init];
    if (self) {
        self.title = title;
        
        if ([self.title isEqualToString:@"gender"]) {
            self.options = [[NSArray alloc] initWithObjects:@"Any", @"Female", @"Male", nil];
        }
        if ([self.title isEqualToString:@"tone"]) {
            self.options = [[NSArray alloc] initWithObjects:@"Any",@"Comedic", @"Tragic", @"Historic", nil];
        }
        if ([self.title isEqualToString:@"length"]) {
            self.options = [[NSArray alloc] initWithObjects: @"Any", @"< 1 minute", @"< 2 minutes", @"> 2 minutes", nil];
        }
        if ([self.title isEqualToString:@"size"]) {
            self.options = [[NSArray alloc] initWithObjects: @"Normal", @"Large", @"Very Large", @"Largest", nil];
        }
        self.currentSetting = self.options[0];
    }

    return self;
}

@end
