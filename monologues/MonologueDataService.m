//
//  MonologueDataService.m
//  Yorick
//
//  Created by TerryTorres on 1/24/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "MonologueDataService.h"

@implementation MonologueDataService


#pragma mark: Initializer and Setter

// Initialization varies between Browse and Favorites controllers
-(id)initWithManager:(MonologueManager*)manager andDisplayArray:(NSMutableArray*)displayArray {
    self.manager = manager;
    _displayArray = displayArray;
    self.sections = [self getAlphabeticalSections:_displayArray];
    
    return self;
}

// This will automatically update the alphabetical sections when the array is upated.
- (void) setDisplayArray:(NSArray *)displayArray {
    _displayArray = displayArray;
    if (!_searchActive) {
        self.sections = [self getAlphabeticalSections:_displayArray];
    }
}


#pragma mark: TableView Methods
// Methods vary between Browse and Favorites controllers

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchActive || _isForFavorites) {
        return 1;
    } else {
        return self.sections.count;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
            rows = (int)monologueArray.count;
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

        currentMonologue = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
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
    // Go through the monologues and create our section keys
    for (Monologue *monologue in monologuesArray) {
        found = NO;
        
        NSString *firstLetter = [monologue.sortTitle substringToIndex:1];
        
        // Put the magnifiying glass at the top of the index to lead to the search bar.
        [sections setValue:[[NSMutableArray alloc] init] forKey:UITableViewIndexSearch];
        
        for (NSString *str in [sections allKeys])
        {
            if ([str isEqualToString:firstLetter])
            {
                found = YES;
            }
        }
        
        // Makes sure first letter isn't a nil value
        if (!found && firstLetter)
        {
            [sections setValue:[[NSMutableArray alloc] init] forKey:firstLetter];
        }
        i++;
    }
    int o = 0;

    // Go through again and sort monologues into their respective sections
    for (Monologue *monologue in monologuesArray)
    {
        [[sections objectForKey:[monologue.sortTitle substringToIndex:1]] addObject:monologue];
        o++;
    }
    
    return sections;
    
}

@end
