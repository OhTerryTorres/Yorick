//
//  MonologueManager.h
//  Yorick
//
//  Created by TerryTorres on 1/24/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monologue.h"
#import "Setting.h"

@interface MonologueManager : NSObject

@property (strong, nonatomic) NSArray *monologues;
@property (strong, nonatomic) NSMutableArray *favoriteMonologues;

@property (strong, nonatomic) NSMutableArray *allTags;
@property (strong, nonatomic) NSArray *settings;

@property int latestUpdateCount;


-(NSArray*)filterMonologuesForSettings:(NSArray*)monologuesArray;
-(NSArray*)filterMonologues:(NSArray*)monologuesArray forSearchString:(NSString*)searchString;
-(void)addTagsFromArrayOfMonologues:(NSArray*)monologuesArray;
-(Monologue*)getMonologueForIDNumber:(int)idNumber;
-(Monologue*)getFavoriteMonologueForIDNumber:(int)idNumber;
-(BOOL)monologueWithIDNumberIsInFavorites:(int)idNumber;
-(void)updateMonologuesWithArrayOfMonologues:(NSArray*)updatedMonologues;


@end
