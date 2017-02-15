//
//  Monologue.h
//  Yorick
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MonologueTableViewCell.h"

@interface Monologue : NSObject

@property (nonatomic) int idNumber;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *authorFirst;
@property (nonatomic, copy) NSString *authorLast;
@property (nonatomic, copy) NSString *character;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *tone;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *length;

@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *tags;

@property (strong, nonatomic) MonologueTableViewCell *cell;

// This allows for alphabetical sorting when dealing with titles starting with "a", "the", etc.
// Trying to minimize the proliferation of this value to reduce headaches, but I may have to reverse that thought
@property (nonatomic, copy) NSString *sortTitle;

// Used for finded related monologues
@property (nonatomic) int matches;

-(id)initWithidNumber:(int)idNumber title:(NSString*)title authorFirst:(NSString*)authorFirst authorLast:(NSString*)authorLast character:(NSString*)character text:(NSString*)text  gender:(NSString*)gender tone:(NSString*)tone period:(NSString*)period age:(NSString*)age length:(NSString*)length notes:(NSString*)notes tags:(NSString*)tags;

@end
