//
//  MonologueManager.m
//  Yorick
//
//  Created by TerryTorres on 1/24/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "MonologueManager.h"

@implementation MonologueManager


# pragma mark: INITIALIZING METHODS

// This will only ever be run the first time the app is used.
-(id)init {
    self = [super init];
    if (self) {
        self.monologues = [self loadMonologuesFromDisk];
        self.favoriteMonologues = [[NSMutableArray alloc] init];
        self.allTags = [[NSMutableArray alloc] init];
        self.activeTags = [[NSMutableSet alloc] init];
        [self addTagsFromArrayOfMonologues: self.monologues];
        // When updating from server, simply add [self getTagsFromArrayOfMonologues: monologues] directly as an object
        
        // add tutorial monologue to favorites array on first initialization
        Monologue* tutorial = [[Monologue alloc] initWithidNumber:305
                                      title:@"Welcome to Yorick"
                                authorFirst:@""
                                 authorLast:@""
                                  character:@"Team Yorick"
                                       text:@"This is the monologue screen. It's where you read the monologue you selected!\n\nThis monologue is in your Digs list. You can tell, because the Dig button is highlighted in the upper right.\n\nWhen you want to remove this entry from your Digs list, tap the Dig button and it will go back to the Boneyard.\n\nWhile a monologue is in your Digs list, you can touch Edit to make alterations to the monologue, like making cuts, adding line breaks, or adding your own notes. You can also add a new tag to the monologue to make it easier for you and others to search for similar monologues."
                                     gender:@""
                                       tone:@""
                                     period:@""
                                        age:@""
                                     length:@""
                                      notes:@"How to make the best use of Yorick"
                                       tags:@"!caretaker !servant !giving !protecting"];
        [self.favoriteMonologues addObject:tutorial];
        
        self.settings = [self loadSettings];
    }
    
    return self;
}

-(NSArray*)loadMonologuesFromDisk {
    
    // Create dictionary to access plist
    NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"monologueList" ofType:@"plist"];
    NSMutableDictionary *sourceDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:documentPath];
    
    NSArray *keys = [sourceDictionary allKeys];
    NSMutableArray *monologuesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < keys.count; i++) {
        
        NSDictionary *currentMonologueDictionary = [[NSMutableDictionary alloc] initWithDictionary:[sourceDictionary objectForKey:[NSString stringWithFormat:@"%d",i]]];
        
        // Create Monologue class object
        Monologue * monologue = [[Monologue alloc] initWithidNumber:i
                                                              title:[currentMonologueDictionary objectForKey:@"title"]
                                                        authorFirst:[currentMonologueDictionary objectForKey:@"authorFirst"]
                                                         authorLast:[currentMonologueDictionary objectForKey:@"authorLast"]
                                                          character:[currentMonologueDictionary objectForKey:@"character"]
                                                               text:[currentMonologueDictionary objectForKey:@"text"]
                                                             gender:[currentMonologueDictionary objectForKey:@"gender"]
                                                               tone:[currentMonologueDictionary objectForKey:@"tone"]
                                                             period:[currentMonologueDictionary objectForKey:@"period"]
                                                                age:[currentMonologueDictionary objectForKey:@"age"]
                                                             length:[currentMonologueDictionary objectForKey:@"length"]
                                                              notes:[currentMonologueDictionary objectForKey:@"notes"]
                                                               tags:[currentMonologueDictionary objectForKey:@"tags"]];
        
        [monologuesArray addObject:monologue];

    }

    return [self sortMonologues: monologuesArray];
}

-(NSArray*)sortMonologues:(NSMutableArray*)sourceArray {

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortTitle" ascending:YES];
    NSArray* sortedArray = [sourceArray sortedArrayUsingDescriptors:@[sort]];
    
    return sortedArray;
}

-(NSArray*)loadSettings {
    // Each setting's cell and picker properties are defined on
    // on the Settings screen. No need to use them earlier than that.

    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    Setting* settingGender = [[Setting alloc] initWithTitle:@"gender"];
    [settings addObject:settingGender];
    
    Setting* settingTone = [[Setting alloc] initWithTitle:@"tone"];
    [settings addObject:settingTone];
    
    Setting* settingLength = [[Setting alloc] initWithTitle:@"length"];
    [settings addObject:settingLength];

    Setting* settingSize = [[Setting alloc] initWithTitle:@"size"];
    [settings addObject:settingSize];
    
    return settings;
}


#pragma mark: FILTERS

-(NSArray*)filterMonologuesForSettings:(NSArray*)monologuesArray {
    for(Setting* setting in self.settings) {
        if (setting.currentSetting != setting.options[0] && ![setting.title isEqualToString:@"size"]) {
            NSPredicate *predicate = nil;
            if ( [setting.title isEqualToString:@"gender"] ) {
                if ( ([setting.currentSetting rangeOfString:@"male" options:NSCaseInsensitiveSearch].location != NSNotFound && [setting.currentSetting  rangeOfString:@"female" options:NSCaseInsensitiveSearch].location == NSNotFound) )  {
                    
                    predicate = [NSPredicate predicateWithFormat:@"%K matches[c] %@ OR %K matches[c] %@", setting.title, setting.currentSetting , setting.title, @"any"];
                } else {
                    predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@ OR %K matches[c] %@", setting.title,setting.currentSetting , setting.title, @"any"];
                }
            } else {
                predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", setting.title, setting.currentSetting];
            }
            
            monologuesArray = [monologuesArray filteredArrayUsingPredicate:predicate];
            
        }
        
    }
    
    // Filter for active tags
    if (self.activeTags.count > 0) {
        monologuesArray = [self filterMonologuesForActiveTags:monologuesArray];
    }
    
    return monologuesArray;
}

-(NSArray*)filterMonologuesForActiveTags:(NSArray*)monologuesArray {
    NSMutableArray *predicatesList = [NSMutableArray array];
    for (NSString *tag in self.activeTags) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"tags contains[cd] %@",tag];
        [predicatesList addObject:predicate];
    }
    NSCompoundPredicate *compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                                         subpredicates:predicatesList];
    return [monologuesArray filteredArrayUsingPredicate:compoundPredicate];
}

-(NSArray*)filterMonologues:(NSArray*)monologuesArray forSearchString:(NSString*)searchString {
    NSString *sep = @", ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    searchString = [searchString stringByReplacingOccurrencesOfString:@", " withString:@" "];
    
    NSArray *queries = [searchString componentsSeparatedByCharactersInSet:set];
    
    NSMutableArray *predicatesList = [NSMutableArray array];
    
    for (NSString *q in queries) {
        if ([q length] > 0) {
            NSPredicate* titlePredicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@",q];
            NSPredicate* characterPredicate = [NSPredicate predicateWithFormat:@"character contains[cd] %@",q];
            NSPredicate* genderPredicate = [NSPredicate predicateWithFormat:@"gender contains[cd] %@",q];
            NSPredicate* tonePredicate = [NSPredicate predicateWithFormat:@"tone contains[cd] %@",q];
            NSPredicate* tagsPredicate = [NSPredicate predicateWithFormat:@"tags contains[cd] %@",q];
            
            // Text predicate variations
            // This makes it so that when the text is filtered with prediciates, it looks up whole words, not part of words
            // i.e., search for "butt" won't return monologue with "button"
            NSString *q1 = [NSString stringWithFormat:@"%@ ",q];
            NSString *q2 = [NSString stringWithFormat:@"%@.",q];
            NSString *q3 = [NSString stringWithFormat:@"%@,",q];
            NSString *q4 = [NSString stringWithFormat:@"%@;",q];
            NSString *q5 = [NSString stringWithFormat:@"%@\n",q];
            NSString *q6 = [NSString stringWithFormat:@"%@s",q];
            NSString *q7 = [NSString stringWithFormat:@"%@es",q];
            NSString *q8 = [NSString stringWithFormat:@"%@d",q];
            NSString *q9 = [NSString stringWithFormat:@"%@ed",q];
            NSString *q10 = [NSString stringWithFormat:@"%@-",q];
            NSString *q11 = [NSString stringWithFormat:@"%@?",q];
            NSString *q12 = [NSString stringWithFormat:@"%@!",q];
            NSString *q13 = [NSString stringWithFormat:@"%@:",q];
            NSString *q14 = [NSString stringWithFormat:@"%@ing",q];
            NSString *q15 = [NSString stringWithFormat:@"%@in'",q];
            NSPredicate* textPredicate = [NSPredicate predicateWithFormat:@"text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@",q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15];
            NSPredicate* notesPredicate = [NSPredicate predicateWithFormat:@"notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@",q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15];
            
            NSCompoundPredicate *orCompoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:[NSArray arrayWithObjects:titlePredicate, characterPredicate, genderPredicate, tonePredicate, notesPredicate, tagsPredicate, textPredicate, nil]];
            
            [predicatesList addObject:orCompoundPredicate];
        }
    }
    
    NSCompoundPredicate *compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                                 subpredicates:predicatesList];
    monologuesArray = [monologuesArray filteredArrayUsingPredicate:compoundPredicate];
    return monologuesArray;
}



# pragma mark: ACCESS METHODS


-(void)addTagsFromArrayOfMonologues:(NSArray*)monologuesArray {
    NSString *sep = @" ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    
    for (Monologue* monologue in monologuesArray) {
        NSArray *tags = [[monologue.tags stringByReplacingOccurrencesOfString:@"!" withString:@""] componentsSeparatedByCharactersInSet:set];
        for (NSString* tag in tags) {
            if (![self.allTags containsObject:tag] && ![tag isEqualToString:@""]) {
                [self.allTags addObject:tag];
            }
        }
    }
    self.allTags = [[self.allTags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
}

-(Monologue*)getMonologueForIDNumber:(int)idNumber {
    for (Monologue* monologue in self.monologues) {
        if ( monologue.idNumber == idNumber ) {
            return monologue;
        }
    }
    return nil;
}
-(Monologue*)getFavoriteMonologueForIDNumber:(int)idNumber {
    for (Monologue* monologue in self.favoriteMonologues) {
        if ( monologue.idNumber == idNumber ) {
            return monologue;
        }
    }
    return nil;
}
-(BOOL)monologueWithIDNumberIsInFavorites:(int)idNumber {
    for (Monologue* monologue in self.favoriteMonologues) {
        if ( monologue.idNumber == idNumber ) {
            return true;
        }
    }
    return false;
}

-(void)updateMonologuesWithArrayOfMonologues:(NSArray*)updatedMonologues {
    // Update existing monologues
    NSMutableArray *localMonologues = [self.monologues mutableCopy];
    for (int i = 0; i < localMonologues.count; i++) {
        Monologue *localMonologue = localMonologues[i];
        for (int ii = 0; ii < updatedMonologues.count; ii++) {
            Monologue *updatedMonologue = updatedMonologues[ii];
            if ( localMonologue.idNumber == updatedMonologue.idNumber ) {
                localMonologues[i] = updatedMonologue;
            }
        }
    }
    
    // Update any favorite monologues
    for (int i = 0; i < self.favoriteMonologues.count; i++) {
        Monologue *favoriteMonologue = self.favoriteMonologues[i];
        for (int ii = 0; ii < updatedMonologues.count; ii++) {
            Monologue *updatedMonologue = updatedMonologues[ii];
            if ( favoriteMonologue.idNumber == updatedMonologue.idNumber ) {
                self.favoriteMonologues[i] = [[Monologue alloc] initWithidNumber:updatedMonologue.idNumber
                                                               title:updatedMonologue.title
                                                         authorFirst:updatedMonologue.authorFirst
                                                          authorLast:updatedMonologue.authorLast
                                                           character:updatedMonologue.character
                                                                text:favoriteMonologue.text
                                                              gender:updatedMonologue.gender
                                                                tone:updatedMonologue.tone
                                                              period:updatedMonologue.period
                                                                 age:updatedMonologue.age
                                                              length:updatedMonologue.length
                                                               notes:updatedMonologue.notes
                                                                tags:updatedMonologue.tags];
            }
        }
    }
    
    // Add new monologues
    for (int i = 0; i < updatedMonologues.count; i++) {
        Monologue *updatedMonologue = updatedMonologues[i];
        if ( [self getMonologueForIDNumber:updatedMonologue.idNumber] == nil ) {
            [localMonologues addObject:updatedMonologues[i]];
        }
    }
    
    self.monologues = [[NSArray alloc] initWithArray:localMonologues];
    
}


#pragma mark: NSCODING

- (id)initWithCoder:(NSCoder *)decoder {
    if ( self = [super init] ) {
        self.monologues = [decoder decodeObjectForKey:@"monologues"];
        self.favoriteMonologues = [decoder decodeObjectForKey:@"favoriteMonologues"];
        self.allTags = [decoder decodeObjectForKey:@"allTags"];
        self.activeTags = [decoder decodeObjectForKey:@"activeTags"];
        self.settings = [decoder decodeObjectForKey:@"settings"];
        self.latestUpdateCount = [decoder decodeIntForKey:@"latestUpdateCount"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.monologues forKey:@"monologues"];
    [encoder encodeObject:self.favoriteMonologues forKey:@"favoriteMonologues"];
    [encoder encodeObject:self.allTags forKey:@"allTags"];
    [encoder encodeObject:self.activeTags forKey:@"activeTags"];
    [encoder encodeObject:self.settings forKey:@"settings"];
    [encoder encodeInt:self.latestUpdateCount forKey:@"latestUpdateCount"];
}



@end
