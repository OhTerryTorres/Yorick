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


// When filters and search strings start to come in, it will make sense for ther to be a
// "display" array of monologues that can initialized with allMonologues/favoriteMonologues
// and then be manipulated as necessary.
// Would it make the most sense for monologue manager to have a "displayMonologues" array?
// Or should each view have their own array of monologues currently being displayed?
// Either could work... Let's start with the former and see how that goes.

/* Things this class needs to do
 
 Load and sort available monologues on initialization
 Return monologue with index
 Return favorite monologue with index
 Filter array of monologues from other view based on current settings
 Filter array of monologues from other view based on search results
 Provide data for alphabetical sections in table views
 
 Maybe the manager can also store other things, like settings from the Settings screen?
 Or the current search string? Or the last selected tag?
 If each screen has a manager, could they communicate by notification?
 At the very least, each screen could pass the manager to the other...
 Let's start by making the manager work for the Browse screen, then move on from there.
*/

-(NSMutableArray*)loadMonologuesFromDisk;
-(NSMutableArray*)sortMonologues:(NSMutableArray*)sourceArray;
-(NSArray*)filterMonologuesForSettings:(NSArray*)monologuesArray; // filterMonologues
-(NSArray*)filterMonologues:(NSArray*)monologuesArray forSearchString:(NSString*)searchString; // check filterContentForSearchText
-(void)addTagsFromArrayOfMonologues:(NSArray*)monologuesArray;
-(Monologue*)getMonologueForIDNumber:(int)idNumber;
-(Monologue*)getFavoritesMonologueForIDNumber:(int)idNumber;
-(BOOL)monologueWithIDNumberIsInFavorites:(int)idNumber;
-(void)updateMonologuesWithArrayOfMonologues:(NSArray*)updatedMonologues;


@end
