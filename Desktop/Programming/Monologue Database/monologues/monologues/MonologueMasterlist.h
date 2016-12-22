//
//  MonologueMasterlist.h
//  Yorick
//
//  Created by TerryTorres on 3/25/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monologue.h"

@interface MonologueMasterlist : NSObject

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableDictionary *sections;

@property (nonatomic) NSString *sortSetting;

-(NSMutableArray*)compileMasterlist:(BOOL)favorites;
+(NSMutableArray*)sortMonologues:(NSMutableArray*)sourceArray;
-(NSMutableDictionary*)getAlphabeticalSections:(NSMutableArray*)monologuesArray;
+(NSMutableArray*)filterMonologues:(NSMutableArray*)array;

@end
