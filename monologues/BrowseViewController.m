//
//  FirstViewController.m
//  monologues
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController {
    NSMutableArray *monologuesArray;
    NSMutableArray *searchResults;
}
// unwind segue
- (IBAction)searchTag:(UIStoryboardSegue *)segue {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.tabBarController.tabBar.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    
    [self loadMonologuesArray];
    
    self.title = @"Boneyard";
    
    self.tableView.tintColor = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidLoad before checkUpdates");
    [self checkUpdates];
    NSLog(@"viewDidLoad after checkUpdates");
}

-(void) checkUpdates {
    NSLog(@"checkUpdates");
    NSString *strURL = [NSString stringWithFormat:@"http://www.terry-torres.com/yorick/api/api.php?method=checkUpdates"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    //
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"checkUpdates Connection begin");
                               
                               if (connectionError) {
                                   NSLog(@"connection error");
                               } else if (response != nil) {
                                   
                                   // receive returned value
                                   NSString *strResults = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   self.latestUpdateCount = [strResults intValue];
                                   unsigned long updatesOnDevice = 0;
                                   
                                   // Check to see if updates stored on device matches updates returned via echo from database
                                   // Check to see if device even has a record of updates
                                   if ( ![[NSUserDefaults standardUserDefaults] integerForKey:@"updates"] ) {
                                       [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"updates"];
                                   } else {
                                       updatesOnDevice = [[NSUserDefaults standardUserDefaults] integerForKey:@"updates"];
                                   }
                                   if ( updatesOnDevice != self.latestUpdateCount ) {
                                       NSLog(@"updates on device is %d",self.latestUpdateCount);
                                       NSLog(@"updates in database is %d", [strResults intValue]);
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                UIBarButtonItem *updateButton = [[UIBarButtonItem alloc]
                                                                          initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                          target:self
                                                                          action:@selector(updateMonologues:)];
                                                self.navigationItem.rightBarButtonItem = updateButton;
                                            }];
                                   }
                                   
                                   NSLog(@"Connection complete");
                               }}];
}

-(IBAction)updateMonologues:(id)sender {
    NSLog(@"in updateMonologues");
    NSString *strURL = [NSString stringWithFormat:@"http://www.terry-torres.com/yorick/api/api.php?method=getUpdates"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    //
    
    __block NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
    NSMutableArray *updatedMonologues = [[NSMutableArray alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"updateMonologues Connection begin");
                               
                               if (connectionError) {
                                   NSLog(@"error");
                               } else if (response != nil) {
                                   
                                   jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
                                   NSLog(@"updateMonologues Async JSON: %@", jsonArray);
                                   
                                   NSMutableDictionary* newMonologueDictionary = [[NSMutableDictionary alloc] init];
                                   
                                   // Set up dictionary with titles and their hashtags
                                   // This will be stored and used in the gallery later.
                                   //NSMutableDictionary *achievementTitlesWithHashtags = [[NSMutableDictionary alloc] init];
                                   
                                   // Loop through JSON array
                                   for ( int i = 0; i < jsonArray.count; i++ ) {
                                       // Create Achievement object
                                       // Here the Achievement object is being used to hold data for recent events
                                       NSMutableDictionary *currentMonologueDictionary = [[NSMutableDictionary alloc] init];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"authorFirst"] forKey:@"authorFirst"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"authorLast"] forKey:@"authorLast"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"character"] forKey:@"character"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"text"] forKey:@"text"];
                                       
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"gender"] forKey:@"gender"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"tone"] forKey:@"tone"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"period"] forKey:@"period"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"age"] forKey:@"age"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"length"] forKey:@"length"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"notes"] forKey:@"notes"];
                                       [currentMonologueDictionary setObject:[[jsonArray objectAtIndex:i] objectForKey:@"tags"] forKey:@"tags"];

                                       
                                       [updatedMonologues addObject:currentMonologueDictionary];
                                       
                                       currentMonologueDictionary = nil;
                                   }
                                   // receive returned value
                                   NSString *strResults = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   
                                   
                                   // Access plist on device an replace old monologues with updatedMonologues.
                                   // Put in an IF statement for monologues with new titles and new ids.
                                   
                                   NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                   documentPath = [documentPath stringByAppendingPathComponent:@"monologueList.plist"];
                                
                                   
                                   newMonologueDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:documentPath];
                                   NSMutableArray *keys = [[newMonologueDictionary allKeys]mutableCopy];
                                   NSLog(@"keys.count on load is %lu",(unsigned long)keys.count);
                                   
                                   for (int i = 0; i < updatedMonologues.count; i++) {
                                       NSMutableDictionary *currentMonologueDictionary = [[NSMutableDictionary alloc] initWithDictionary:updatedMonologues[i]];
                                       NSString *keyString = [currentMonologueDictionary objectForKey:@"id"];
                                       [newMonologueDictionary setObject:currentMonologueDictionary forKey:keyString];
                                       NSLog(@"keyString is %@", keyString);
                                   }
                                   
                                
                                   NSLog(@"here we go!!");
                                   
                                   
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                       
                                       
                                       
                                       
                                       if ( [[NSFileManager defaultManager] fileExistsAtPath:documentPath] ) {
                                           NSLog(@"the file does exist!");
                                       }
                                       
                                       [newMonologueDictionary writeToFile:documentPath atomically:YES];
                                       
                                       NSLog(@"strResults is %@",strResults);
                                       
                                       
                                       
                                       NSMutableArray *keys = [[newMonologueDictionary allKeys]mutableCopy];
                                       NSLog(@"keys.count on write is %lu",(unsigned long)keys.count);
                                       
                                       NSMutableDictionary *monologueDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:documentPath];
                                       keys = [[monologueDictionary allKeys]mutableCopy];
                                       NSLog(@"keys.count on reload is %lu",(unsigned long)keys.count);
                                       
                                       
                                       
                                       [self loadMonologuesArray];
                                       
                                       [self.tableView reloadData];
                                       
                                       int count = (int)monologuesArray.count;
                                       NSString *headerTitle = [NSString stringWithFormat:@"Boneyard (%d)",count];
                                       [self.navigationItem setTitle:headerTitle];
                                       self.navigationItem.rightBarButtonItem = nil;
                                       
                                       [[NSUserDefaults standardUserDefaults] setInteger:self.latestUpdateCount forKey:@"updates"];
                                       
                                       NSLog(@"Connection complete");
                                   }];
                                   
                               }}];


}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // ****
    // Embedding all of these function in this IF statement
    // Makes it so that the search results aren't fucked up
    // When switching between tabs.
    // Hopefully this won't come back to bite us in the ass.
    // If it does, simply figure out which functions
    // in particular need to be within or without the IF statement.
    // ****
    
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"settingsList"] ) {
        if ( self.tableView == self.searchDisplayController.searchResultsTableView ) {
            searchResults = [[MonologueMasterlist filterMonologues:searchResults] mutableCopy];
        } else {
            NSLog(@"GLAGLA1");
            monologuesArray = [[MonologueMasterlist filterMonologues:monologuesArray] mutableCopy];
            // *****
            // This updates the alphabetical index with the filtered monologuesArray
            self.masterlist.sections = [self.masterlist getAlphabeticalSections:monologuesArray];
        }
    }
    
    [self searchTagNotification];
    
    if ( self.tableView != self.searchDisplayController.searchResultsTableView ) {
        searchResults = [MonologueMasterlist sortMonologues:searchResults];
    } else {
        monologuesArray = [MonologueMasterlist sortMonologues:monologuesArray];
    }
    
    // This displays the amount of monologues currently in the list
    int count = (int)monologuesArray.count;
    NSString *headerTitle = [NSString stringWithFormat:@"Boneyard (%d)",count];
    
    [self.navigationItem setTitle:headerTitle];
    [self reloadSearchBar];
    
    [self.tableView reloadData];
    
}



// Define the array that holds and lists all monologues.
-(void)loadMonologuesArray {
    
    monologuesArray = [[NSMutableArray alloc] init];
    
    
    self.masterlist = [[MonologueMasterlist alloc] init];
    self.masterlist.array = [self.masterlist compileMasterlist:NO];
    monologuesArray = self.masterlist.array;
    self.masterlist.sections = [self.masterlist getAlphabeticalSections:monologuesArray];


}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [[self.masterlist.sections allKeys] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        // *****
        // Both the searchDisplayController and the regular view controller are active upon returning from the monologue screen to a search
        // This code nullifies the section index titles so that empty sections don't end up appearing on top of the table.
        //
        NSString *title = [[[self.masterlist.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
        if ( self.searchDisplayController.isActive ) {
            title = nil;
        }
        return title;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        CGRect searchBarFrame = self.searchDisplayController.searchBar.frame;
        [tableView scrollRectToVisible:searchBarFrame animated:NO];
        return -1;
    } else {
        return index;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Different view for search results
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    } else {
        // ******
        // Doublecheck this, it may be weird
        // ******
        return [[self.masterlist.sections valueForKey:[[[self.masterlist.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    }
}

// This gets rid of the empty section that appears along with the magnifying glass on the side index
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if ( !self.searchDisplayController.isActive ) {
        if ( section == 0 ) {
            height = 0;
        } else {
            height = UITableViewAutomaticDimension;
        }
    } else {
        height = UITableViewAutomaticDimension;
    }
    return height;
}

// This returns the alphabetical sections
// There is currently no alphabetical index during a search.
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        
        return [[self.masterlist.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
}


// This keeps the height of the rows during a search from collapsing
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Monologue *currentMonologue = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentMonologue = [searchResults objectAtIndex:indexPath.row];
    } else {
        // This is in keeping all all the alphabetical shit we're trying to do
        // Thanks again to icodeblog for the help!!!!!!!
        currentMonologue = [[self.masterlist.sections valueForKey:[[[self.masterlist.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    // Make sure the reuse identifier in the Prototype Cell says "cell"
    // self.tableView (as opposed to just tableView) below was crucial to stop crashing during searches
    currentMonologue.cell = [[MonologueTableViewCell alloc] init];
    
    currentMonologue.cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    currentMonologue.cell.titleLabel.text = currentMonologue.title;
    currentMonologue.cell.characterLabel.text = currentMonologue.character;
    
    NSString *excerptString = currentMonologue.text;
    excerptString = [self excerptLabelFilter:excerptString];
    NSUInteger length = [excerptString length];
    if (length > 300) { length = 300; };
    // define the range you're interested in
    NSRange stringRange = {0, MIN([excerptString length], length)};
    // adjust the range to include dependent chars
    stringRange = [excerptString rangeOfComposedCharacterSequencesForRange:stringRange];
    // Now you can create the short string
    excerptString = [excerptString substringWithRange:stringRange];
    excerptString = [self excerptLabelFilter:excerptString];
    currentMonologue.cell.excerptLabel.text = excerptString;
    
    return currentMonologue.cell;
    
}

-(NSString*)excerptLabelFilter:(NSString *)targetString {
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@" "];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n\n" withString:@" "];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return targetString;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.20
                     animations: ^{
                         // Animate the views on and off the screen.
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         cell.frame = CGRectMake(-cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                         cell.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [self performSegueWithIdentifier:@"segue" sender:self];
                         }];
}


// This is what creates the filter for the manual search
// The predicate is a BOOL that returns YES or NO depending on whether or not there is a match.
// "title" refers to monologue.title
// [c] refers to case insensitivity, as opposed to [C]
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{

    NSString *sep = @", ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    searchText = [searchText stringByReplacingOccurrencesOfString:@", " withString:@" "];
    
    NSMutableArray *array = [[searchText componentsSeparatedByCharactersInSet:set] mutableCopy];
    
    // The array splits up searchText based on dividing characters.
    // However, this split creates a new element immediately that's just a "" string. This empties the search results.
    // This if statement ignores empty elements in the array, only recognizing a new element when a non-space character is entered.
    // It's great!
    
    if ( [array.lastObject isEqualToString:@""] || [array.lastObject isEqualToString:@" "] ) {
        // This keeps array from destroying itself and crashing.
        if ( array.count > 1 ) {
            [array removeLastObject];
        }
    }
    
    NSMutableArray *subPredicates = [NSMutableArray array];
    
    for (NSString *q in array) {
        [subPredicates addObject:
         [NSPredicate predicateWithFormat:@"title contains[cd] %@ OR character contains[cd] %@ OR authorFirst contains[cd] %@ OR authorLast contains[cd] %@ OR text contains[cd] %@ OR gender contains[cd] %@ OR tone contains[cd] %@ OR period contains[cd] %@ OR age contains[cd] %@ OR length contains[cd] %@ OR notes contains[cd] %@ OR tags contains[cd] %@", q, q, q, q, q, q, q, q, q, q, q, q]];
    }
    
    NSCompoundPredicate *predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                                  subpredicates:subPredicates];
    
    searchResults = [[monologuesArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
}


// This updates the search display each time the search string is altered.
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

// This updates the search results in the searchDisplayController.
// Calling this is useful for when the view should be reloaded between tabs / when the filters have changed.
-(void)reloadSearchBar {
    if ( self.searchDisplayController.isActive ) {
        [self filterContentForSearchText:self.searchBar.text
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

// Here we make sure the monologuesArray is correct, even after the table has been showing searchResults instead.
// Also, it scrolls to the top of the table.
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    monologuesArray = [MonologueMasterlist sortMonologues:monologuesArray];
    [self.tableView reloadData];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // This prepares the monologue to appear in the monologue screen.
    // (unless segueing to the Settings screen)
    if ( ![segue.identifier isEqualToString:@"settings"] ) {
        // Get the new view controller using [segue destinationViewController].
        MonologueViewController *mvc = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        // What's the selected cell.
        NSIndexPath *path = [[NSIndexPath alloc]init];
        // indexPathForSelectedRow loads two variables into path: section and row.
        // Now we ask for just the row and set that to c.
        Monologue *c = nil;
        if ( self.searchDisplayController.active ) {
            path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            c = searchResults[path.row];
            // For swipe gesture
            mvc.detailsDataSource = [[NSArray alloc] initWithArray:searchResults];
            // For swipe gesture
            mvc.detailIndex = [searchResults indexOfObject:c];
        } else {
            path = [self.tableView indexPathForSelectedRow];
            // Use the same code from cellForRowAtIndexPath to access the appropriate monologue from self.masterlist.sections
            c = [[self.masterlist.sections valueForKey:[[[self.masterlist.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:path.section]] objectAtIndex:path.row];
            // For swipe gesture
            mvc.detailsDataSource = [[NSArray alloc] initWithArray:monologuesArray];
            // For swipe gesture
            mvc.detailIndex = [monologuesArray indexOfObject:c];
        }
        
        mvc.currentMonologue = c;
        
        
        // This keeps the MonologueViewController from skipping any lines in the monologue when accessed from the Browse Screen.
        mvc.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    

}

// This allows the Browse screen to display a search when a tag is touched in the Monologue screen.
-(void)searchTagNotification {
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"tagSearch"] ) {
        NSLog(@"searchTagNotification success");
        NSString *updatedText = [[NSUserDefaults standardUserDefaults] objectForKey:@"tagSearch"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"tagSearch"];
        NSLog(@"tagSearch in Browse is %@",updatedText);
        self.searchDisplayController.active = YES;
        self.searchBar.text = updatedText;
    }

}


- (void)searchTagFromFavorites:(NSNotification*)notification
{
    NSString *updatedText = (NSString*)[notification object];
    NSLog(@"object in Browse is %@",updatedText);
    self.searchDisplayController.active = YES;
    self.searchBar.text = updatedText;
    
}


// ******
// Check this out next!
- (IBAction)showSettings:(id)sender {
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    //svc.delegate = self;
    CGRect newFrame = svc.view.frame;
    newFrame.origin.x = self.view.frame.size.width / 6;
    newFrame.origin.y = self.view.frame.size.height / 7;
    newFrame.size.width = newFrame.size.width * .75;
    newFrame.size.height = newFrame.size.height * .75;
    svc.view.frame = newFrame;
    
    [svc viewDidLoad];
    [self.view.superview addSubview:svc.view];
    
}






@end
