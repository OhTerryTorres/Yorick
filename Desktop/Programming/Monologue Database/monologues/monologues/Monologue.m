//
//  Monologue.m
//  monologues
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "Monologue.h"

@implementation Monologue

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.authorFirst forKey:@"authorFirst"];
    [encoder encodeObject:self.authorLast forKey:@"authorLast"];
    [encoder encodeObject:self.authorLast forKey:@"character"];
    [encoder encodeObject:self.text forKey:@"text"];
    
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.tone forKey:@"tone"];
    [encoder encodeObject:self.period forKey:@"period"];
    [encoder encodeObject:self.age forKey:@"age"];
    [encoder encodeObject:self.length forKey:@"length"];
    
    [encoder encodeObject:self.notes forKey:@"notes"];
    [encoder encodeObject:self.tags forKey:@"tags"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ( self = [super init] ) {
        //decode properties, other class vars
        self.title = [decoder decodeObjectForKey:@"title"];
        self.authorFirst = [decoder decodeObjectForKey:@"authorFirst"];
        self.authorLast = [decoder decodeObjectForKey:@"authorLast"];
        self.character = [decoder decodeObjectForKey:@"character"];
        self.text = [decoder decodeObjectForKey:@"text"];
        
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.tone = [decoder decodeObjectForKey:@"tone"];
        self.period = [decoder decodeObjectForKey:@"period"];
        self.age = [decoder decodeObjectForKey:@"age"];
        self.length = [decoder decodeObjectForKey:@"length"];
        
        self.notes = [decoder decodeObjectForKey:@"notes"];
        self.tags = [decoder decodeObjectForKey:@"tags"];
    }
    return self;
}

@end