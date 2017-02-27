//
//  MonologueDataService.m
//  Yorick
//
//  Created by TerryTorres on 1/24/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "MonologueDataService.h"

@implementation MonologueDataService

// GET SOME TABLEVIEW SHENANIGANS IN HERE!!
// Design this document WITHOUT UISearchController in mind


/*
 Suppose each viewcontroller has a MonologueDataService.
 Each DataService talks to one MonologueManager object.
 This object would be created by the AppDelegate when the 
 app is launched for the very first time. After that, it
 wil be stored in memory.
 This Manager will be passed to the first screen (Favorites).
 Then, any time the ViewWillDisappear, the Manager is passed to
 each different ViewController.
 That should look like this:
 
               ____MANAGER____
             _/       |       \_____
           _/         |             \___
DATASERVICE       DATASERVICE          |
     |                |                |
 FAVORITES  <---->  BROWSE  <----> SETTINGS
      ^-------------------------------^
 
 Here it looks like the Manager is in charge of everything.
 Actually, the manager is more like the power source for everything.
 The Manager can be passed along all of the axises to give each class access.
 
 Here are actions we want to be able to do, and the things that need
 to be done in order to do them:

Browse all monologues:
    Load all monologues from disk into array. (MonologueManager.init)
    Create tableview delegate/datasource. (BrowseViewController.viewDidLoad)
    Send that array to a tableview delegate for display. (BrowseViewController.dataService.displayArray = self.manager.monologues)
Browse all favorited monologues:
    Allow user to add monologues to favorites. (self.manager.addObject: monologue)
    Receive manager reference from other view. (http://stackoverflow.com/questions/2191594/send-and-receive-messages-through-nsnotificationcenter-in-objective-c)
        Perhaps make a protocol that every class can receive such a notification.
    Send favorites array to tableview delegate for display. (FavoritesViewController.dataService.displayArray = self.manager.favoriteMonologues)
Filter monologues in tableview using Settings:
    Change global filter settings. (MonologueManager.settings)
    Filter browse monologues for settings. (in ViewWillDisappear, send notification to Browse controller that triggers filterMonologuesForSettings, set THAT to dataSerice.displayArray)
Filter monologues in tableview with Search:
    Tell dataService search is active to change display properties. (in UISearchController delgate method, self.dataService.searchActive = TRUE)
    Filter current displayArray with searchString. (self.dataService.displayArray = [manager filterMonologues:[self.manager.filterMonologuesForsettings:self.manager.monologues] forSearchString:self.UISearchController.searchBar.text]
 
 Knowing this: which classes needs to hold what information?
 The Manager needs:
    all the monologues
    all of the favorited monlogues
 The Data Service needs:
    the monologues being displayed
 The ViewControllers needs:
    a tableview
    a UISearchController
    reference to the Manager
    a data service, initialized with a set of monologues from the manager
 
 */

#pragma mark: Initializer and Setter

-(id)initWithManager:(MonologueManager*)manager andDisplayArray:(NSMutableArray*)displayArray {
    self.manager = manager;
    _displayArray = displayArray;
    self.sections = [self getAlphabeticalSections:_displayArray];
    
    return self;
}

// This should automatically update the alphabetical sections when the array is upated.
- (void) setDisplayArray:(NSArray *)displayArray {
    _displayArray = displayArray;
    if (!_searchActive) {
        self.sections = [self getAlphabeticalSections:_displayArray];
    }
}


#pragma mark: TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchActive || _isForFavorites) {
        return 1;
    } else {
        return self.sections.count;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (_searchActive || _isForFavorites) {
        return nil;
    } else {
        NSArray *sectionTitles = [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        // Both the searchDisplayController and the regular view controller are active upon returning from the monologue screen to a search
        // This code nullifies the section index titles so that empty sections don't end up appearing on top of the table.
        if ( section < sectionTitles.count) {
            title = sectionTitles[section];
        }
        return title;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        [tableView setContentOffset:CGPointMake(0, 0 - tableView.contentInset.top) animated:NO];
        return -1;
    } else {
        return index;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    // Return the number of rows in the section.
    // Different view for search results
    if (_searchActive || _isForFavorites) {
        return _displayArray.count;
    } else {
        // Before instantiating section titles, crashes could occur where the tableview,
        // on launching with a save set of settings, attempted to access a section that didn't exist.
        NSArray *sectionTitles = [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        if ( section < sectionTitles.count) {
            NSArray *monologueArray = [self.sections valueForKey:[sectionTitles objectAtIndex:section]];
            rows = monologueArray.count;
        }
        return rows;
    }
}

// This gets rid of the empty section that appears along with the magnifying glass on the side index
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if ( !_searchActive  || !_isForFavorites ) {
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
    if ( _searchActive || _isForFavorites ) {
        return nil;
    } else {
        return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Monologue *currentMonologue = nil;
    if (_searchActive || _isForFavorites) {
        currentMonologue = [_displayArray objectAtIndex:indexPath.row];
    } else {
        // This is in keeping all all the alphabetical shit we're trying to do
        // Thanks again to icodeblog for the help!!!!!!!
        currentMonologue = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    // Make sure the reuse identifier in the Prototype Cell says "cell"
    // self.tableView (as opposed to just tableView) below was crucial to stop crashing during searches
    //currentMonologue.cell = [[MonologueTableViewCell alloc] init];
    
    currentMonologue.cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    currentMonologue.cell.titleLabel.text = currentMonologue.title;
    currentMonologue.cell.characterLabel.text = currentMonologue.character;
    [currentMonologue.cell setExcerptLabelWithString: currentMonologue.text];
    
    return currentMonologue.cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"segueByNotification" object:self userInfo:@{@"indexPath": indexPath}];
}

#pragma mark: Alphabetical Lookup

-(NSMutableDictionary*)getAlphabeticalSections:(NSMutableArray*)monologuesArray {
    BOOL found;
    NSMutableDictionary* sections = [[NSMutableDictionary alloc] init];
    
    int i = 0;
    // Loop through the books and create our keys
    for (Monologue *monologue in monologuesArray) {
        
        NSString *c = [monologue.sortTitle substringToIndex:1];
        
        found = NO;
        
        // An attempt to put the magnifiying glass at the top of the index to lead to the search bar.
        [sections setValue:[[NSMutableArray alloc] init] forKey:UITableViewIndexSearch];
        
        for (NSString *str in [sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        // Makes sure there isn't a NULL value
        if (!found && c)
        {
            [sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
        i++;
    }
    int o = 0;

    // Loop again and sort the books into their respective keys
    for (Monologue *monologue in monologuesArray)
    {
        [[sections objectForKey:[monologue.sortTitle substringToIndex:1]] addObject:monologue];
        o++;
    }
    
    return sections;
    
}

@end
