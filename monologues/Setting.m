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

-(int)indexOfCurrentSetting {
    for ( int i = 0; i < self.options.count; i++) {
        if ( [self.options[i] isEqualToString:self.currentSetting] ) {
            return i;
        }
    }
    return 0;
}

#pragma mark: NSCODING

- (id)initWithCoder:(NSCoder *)decoder {
    if ( self = [super init] ) {
        //decode properties, other class vars
        self.options = [decoder decodeObjectForKey:@"options"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.currentSetting = [decoder decodeObjectForKey:@"currentSetting"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.options forKey:@"options"];
    //[encoder encodeObject:self.cell forKey:@"cell"];   // I have no interest in separating the cell
                                                         // functionality from the class,  but I also
                                                        // see no need to save a UIElement to defaults.
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.currentSetting forKey:@"currentSetting"];
}


@end
