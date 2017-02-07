//
//  Monologue.m
//  Yorick
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "Monologue.h"

@implementation Monologue

-(id)initWithidNumber:(int)idNumber title:(NSString*)title authorFirst:(NSString*)authorFirst authorLast:(NSString*)authorLast character:(NSString*)character text:(NSString*)text  gender:(NSString*)gender tone:(NSString*)tone period:(NSString*)period age:(NSString*)age length:(NSString*)length notes:(NSString*)notes tags:(NSString*)tags{
    self.idNumber = [NSString stringWithFormat:@"%d",idNumber];
    self.title = title;
    self.sortTitle = title;
    if ( [title hasPrefix:@"The "] ){
        self.sortTitle = [title substringFromIndex:4];
    } else if ( [title hasPrefix:@"A "] ) {
        self.sortTitle = [title substringFromIndex:2];
    } else if ( [title hasPrefix:@"An "] ) {
        self.sortTitle = [title substringFromIndex:3];
    }
    self.authorFirst = authorFirst;
    self.authorLast = authorLast;
    self.character = character;
    self.text = text;
    
    self.gender = gender;
    self.tone = tone;
    self.period = period;
    self.age = age;
    self.length = length;
    self.notes = notes;
    self.tags = tags;
    return self;
}

#pragma mark: NSCODING

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.sortTitle forKey:@"sortTitle"];
    [encoder encodeObject:self.authorFirst forKey:@"authorFirst"];
    [encoder encodeObject:self.authorLast forKey:@"authorLast"];
    [encoder encodeObject:self.character forKey:@"character"];
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
        self.sortTitle = [decoder decodeObjectForKey:@"sortTitle"];
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
