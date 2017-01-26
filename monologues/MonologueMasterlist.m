//
//  MonologueMasterlist.m
//  Yorick
//
//  Created by TerryTorres on 3/25/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "MonologueMasterlist.h"

@implementation MonologueMasterlist {
    // **** Does this need to exist?
    NSString *sortMethod;
}

-(NSMutableArray*)compileMasterlist:(BOOL)favorites {
    NSMutableArray *monologuesArray = [[NSMutableArray alloc] init];
    self.allTags = [[NSMutableArray alloc] init];
    NSString *sep = @" ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    NSString *tags;
    
    // Create dictionary to access plist
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    documentPath = [documentPath stringByAppendingPathComponent:@"monologueList.plist"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:documentPath] ) {
        NSLog(@"it doesn't exist yet!");
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"monologueList" ofType:@"plist"];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:documentPath error:&error];
    }
    NSMutableDictionary *monologueDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:documentPath];
    
    NSArray *keys = [monologueDictionary allKeys];
    NSLog(@"keys.count in compile is %lu",(unsigned long)keys.count);
    
    int i = 0;
    
    while ( i < keys.count ) {
        
        NSMutableDictionary *currentMonologueDictionary = [[NSMutableDictionary alloc] initWithDictionary:[[monologueDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] mutableCopy]];
        
        // Create Monologue class object
        Monologue * monologue = [[Monologue alloc] init];
        
        monologue.idNumber = [NSString stringWithFormat:@"%d",i];
        monologue.title = [currentMonologueDictionary objectForKey:@"title"];
        monologue.sortTitle = [currentMonologueDictionary objectForKey:@"title"];
        monologue.authorFirst = [currentMonologueDictionary objectForKey:@"authorFirst"];
        monologue.authorLast = [currentMonologueDictionary objectForKey:@"authorLast"];
        monologue.character = [currentMonologueDictionary objectForKey:@"character"];
        monologue.text = [currentMonologueDictionary objectForKey:@"text"];
        
        monologue.gender = [currentMonologueDictionary objectForKey:@"gender"];
        monologue.tone = [currentMonologueDictionary objectForKey:@"tone"];
        monologue.period = [currentMonologueDictionary objectForKey:@"period"];
        monologue.age = [currentMonologueDictionary objectForKey:@"age"];
        monologue.length = [currentMonologueDictionary objectForKey:@"length"];
        monologue.notes = [currentMonologueDictionary objectForKey:@"notes"];
        monologue.tags = [currentMonologueDictionary objectForKey:@"tags"];
        
        // Helps in keeping up to date catalog of all tags used in monologues
        tags = [monologue.tags stringByReplacingOccurrencesOfString:@"!" withString:@""];
        [self compileAllTags:[[tags componentsSeparatedByCharactersInSet:set]mutableCopy]];
        
        
        if ( favorites == YES ) {
            // *****
            // Add tutorial monologues on first use
            NSMutableArray *favoriteMonologueTitles = [[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMonologues"] mutableCopy]];
            
            if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialDisplayed"] == nil ) {
                if ( [monologue.title isEqualToString:@"Welcome to Yorick"] ) {
                    favoriteMonologueTitles = [[NSMutableArray alloc] initWithObjects:monologue.title, nil];
                    [[NSUserDefaults standardUserDefaults] setObject:favoriteMonologueTitles forKey:@"favoriteMonologues"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialDisplayed"];
                }
            }
            if ( [favoriteMonologueTitles containsObject:monologue.title] ) {
                [monologuesArray addObject:monologue];
            }
        } else {
            if ( ![monologue.title isEqualToString:@"Welcome to Yorick"] ) {
                [monologuesArray addObject:monologue];
            }
        }
        
        monologue = nil;
        
        i++;
        
        
    }
    
    // Make tags accessible from elsewhere
    [[NSUserDefaults standardUserDefaults] setObject:self.allTags forKey:@"allTags"];
    
    monologuesArray = [MonologueMasterlist sortMonologues:monologuesArray];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //NSLog(@"allTags is %@",self.allTags);
    
    return monologuesArray;
}

-(void)compileAllTags:(NSMutableArray*)tagsArray {

    int x = 0;
    
    while ( x < tagsArray.count ) {
        if (![self.allTags containsObject:tagsArray[x]]) {
            [self.allTags addObject:tagsArray[x]];
        }
        x++;
    }
    self.allTags = [[self.allTags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    
}


-(NSMutableDictionary*)getAlphabeticalSections:(NSMutableArray*)monologuesArray {
    BOOL found;
    NSString *sort = [[NSUserDefaults standardUserDefaults] objectForKey:@"sortSetting"];
    self.sections = [[NSMutableDictionary alloc] init];
    
    // Loop through the books and create our keys
    for (Monologue *monologue in monologuesArray)
    {
        NSString *c = [sort isEqualToString:@"Author"] ? [monologue.authorLast substringToIndex:1] : [monologue.sortTitle substringToIndex:1];
        
        found = NO;
        
        // An attempt to put the magnifiying glass at the top of the index to lead to the search bar.
        [self.sections setValue:[[NSMutableArray alloc] init] forKey:UITableViewIndexSearch];
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        // Makes sure there isn't a NULL value
        if (!found && c)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    // Loop again and sort the books into their respective keys
    for (Monologue *monologue in monologuesArray)
    {
        if ( [sort isEqualToString:@"Author"] ) {
            [[self.sections objectForKey:[monologue.authorLast substringToIndex:1]] addObject:monologue];
        } else {
            [[self.sections objectForKey:[monologue.sortTitle substringToIndex:1]] addObject:monologue];
        }
    }

    return self.sections;
}



// This sorts monologues alphabetically, either by title or author's last name.
+ (NSMutableArray*)sortMonologues:(NSMutableArray*)sourceArray {
    NSMutableArray *arrayWithoutArticles = [[NSMutableArray alloc] init];
    int i = 0;
    while ( i < sourceArray.count ) {
        Monologue *monologueWithoutArticles = sourceArray[i];
        
        if ( [monologueWithoutArticles.sortTitle hasPrefix:@"The "] ){
            monologueWithoutArticles.sortTitle = [monologueWithoutArticles.sortTitle substringFromIndex:4];
        } else if ( [monologueWithoutArticles.sortTitle hasPrefix:@"A "] ) {
            monologueWithoutArticles.sortTitle = [monologueWithoutArticles.sortTitle substringFromIndex:2];
        } else if ( [monologueWithoutArticles.sortTitle hasPrefix:@"An "] ) {
            monologueWithoutArticles.sortTitle = [monologueWithoutArticles.sortTitle substringFromIndex:3];
        }
        
        [arrayWithoutArticles addObject:monologueWithoutArticles];
        
        monologueWithoutArticles = nil;
        
        i++;
    }
    
    NSString *sort = [[NSUserDefaults standardUserDefaults] objectForKey:@"sortSetting"];
    if ( [sort isEqualToString:@"Author"] ) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"authorLast" ascending:YES];
        sourceArray = [[arrayWithoutArticles sortedArrayUsingDescriptors:@[sort]] mutableCopy];
    } else {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortTitle" ascending:YES];
        sourceArray = [[arrayWithoutArticles sortedArrayUsingDescriptors:@[sort]] mutableCopy];
    }
    
    return sourceArray;
}


// This alters the available monologues based on selection in the Filter screen.
+(NSMutableArray*)filterMonologues:(NSMutableArray*)array {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *settingsList = [[NSArray alloc] initWithArray:[defaults objectForKey:@"settingsList"]];
    NSString *objectForKeyString = [[NSString alloc] init];
    NSString *settingFilter = [[NSString alloc] init];
    
    
    int i = 0;
    while ( i < settingsList.count - 1) {
        NSLog(@"GLAGLA2");
        // **********
        // "i > settingsList.count - 1" to avoid including non-filter settings like Size
        // **********
        objectForKeyString = [NSString stringWithFormat:@"%@Setting",settingsList[i]];
        
        if ( ![defaults objectForKey:objectForKeyString]) {
            settingFilter = @"Any";
        } else {
            settingFilter = [defaults objectForKey:objectForKeyString];
        }
        
        
        //
        // %K was very important here
        //
        
        // This allows us to seperate Male and Female monolouges more completely
        // any monologue with the gender "female male" is include in both
        
        NSPredicate *predicate;
        NSString *femaleMaleString = @"any";
        if ( [settingsList[i] isEqualToString:@"gender"] ) {
            NSLog(@"GLAGLA3");
            if ( ([settingFilter rangeOfString:@"male" options:NSCaseInsensitiveSearch].location != NSNotFound && [settingFilter rangeOfString:@"female" options:NSCaseInsensitiveSearch].location == NSNotFound) )  {
                
                predicate = [NSPredicate predicateWithFormat:@"%K matches[c] %@ OR %K matches[c] %@", settingsList[i] ,settingFilter, settingsList[i], femaleMaleString];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@ OR %K matches[c] %@", settingsList[i] ,settingFilter, settingsList[i], femaleMaleString];
            }
        } else {
            NSLog(@"GLAGLA5");
            predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", settingsList[i] ,settingFilter];
        }
        
        
        if ( ![settingFilter isEqualToString:@"Any"]) {
            array = [[array filteredArrayUsingPredicate:predicate] mutableCopy];
        }
        
        predicate = nil;
        
        i++;
    }
    
    
    return array;
    
}


@end
