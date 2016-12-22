//
//  MonologueMasterlist.m
//  Yorick
//
//  Created by TerryTorres on 3/25/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "MonologueMasterlist.h"

@implementation MonologueMasterlist {
    NSString *sortMethod;
}

-(NSMutableArray*)compileMasterlist:(BOOL)favorites {
    NSMutableArray *monologuesArray = [[NSMutableArray alloc] init];
    
    // Create dictionary to access plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"monologueList" ofType:@"plist"];
    NSMutableDictionary *monologueDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *keys = [monologueDictionary allKeys];
    
    int i = 0;
    
    while ( i < keys.count ) {
        NSMutableDictionary *currentMonologueDictionary = [[NSMutableDictionary alloc] init];
        currentMonologueDictionary = [[monologueDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] mutableCopy];
        
        // Create Monologue class object
        Monologue * monologue = [[Monologue alloc] init];
        
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
        
        
        if ( favorites == YES ) {
            // *****
            // Add tutorial monologues on first use
            NSMutableArray *favoriteMonologueTitles = [[NSMutableArray alloc] init];
            favoriteMonologueTitles = [[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMonologues"] mutableCopy];
            
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
        
        /*
        // Rewriting the length stat for each monologue
        int wordCount = [[monologue.text componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] count];
        NSString *length;
    
        if ( wordCount < 130) {
            length = @"< 1 minute";
        } else if ( wordCount < 260) {
            length = @"< 2 minutes";
        } else if ( wordCount > 260 ) {
            length = @"> 2 minutes";
        }
        
        //NSLog(@"%@: words: %d", monologue.title, wordCount);
        
        //NSLog(@"[currentMonologueDictionary length is %@",[currentMonologueDictionary objectForKey:@"length"]);
        [currentMonologueDictionary setValue:length forKey:@"length"];
        //NSLog(@"[currentMonologueDictionary length is %@",[currentMonologueDictionary objectForKey:@"length"]);
        
        [monologueDictionary setObject:currentMonologueDictionary forKey:[NSString stringWithFormat:@"%d",i]];
        */
        
        monologue = nil;
        
        i++;
    }
    
    /*
    NSMutableDictionary *currentMonologueDictionary = [[monologueDictionary objectForKey:[NSString stringWithFormat:@"%d",2]] mutableCopy];
    NSLog(@"[currentMonologueDictionary length is %@",[currentMonologueDictionary objectForKey:@"length"]);
    
    // Build the path, and create if needed.
    NSString* filePath = @"/Users/user/Documents/";
    NSString* fileName = @"monologueListEdited.plist";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        NSLog(@"DUHHH");
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        NSLog(@"YAY!!");
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"LENGTHLIST.plist"];
    NSLog(plistPath);
    
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSLog(@"DRRRRRRR");
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"monologueList" ofType:@"plist"];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
    }
    
    // The main act...
    [monologueDictionary writeToFile:plistPath atomically:YES];
    */
    
    monologuesArray = [MonologueMasterlist sortMonologues:monologuesArray];
    
    return monologuesArray;
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
        
        if (!found)
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
        Monologue *monologueWithoutArticles = [[Monologue alloc] init];
        monologueWithoutArticles = sourceArray[i];
        
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
    NSLog(@"Filter monologues");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *settingsList = [[NSArray alloc] initWithArray:[defaults objectForKey:@"settingsList"]];
    NSString *objectForKeyString = [[NSString alloc] init];
    NSString *settingFilter = [[NSString alloc] init];
    
    
    int i = 0;
    while ( i < settingsList.count - 2) {
        // **********
        // "i > settingsList.count - 2" to avoid including non-filter settings like Sort and Size
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
        NSString *femaleMaleString = @"female male";
        if ( [settingsList[i] isEqualToString:@"gender"] ) {
            NSLog(@"settingFilter is %@",settingFilter);
            if ( [settingFilter isEqualToString:@"Male"] ) {
                NSLog(@"male");
                predicate = [NSPredicate predicateWithFormat:@"%K matches[c] %@ OR %K matches[c] %@", settingsList[i] ,settingFilter, settingsList[i], femaleMaleString];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", settingsList[i] ,settingFilter];
            }
        } else {
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
