//
//  FavoritesViewController.m
//  monologues
//
//  Created by TerryTorres on 7/15/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController{
    NSMutableArray *favoriteMonologuesArray;
    NSMutableArray *searchResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Digs: View did load");
    
    self.title = @"Digs";
    
    self.tableView.tintColor = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Digs: View will appear");
    
    // ****
    // Embedding all of these function in this IF statement
    // Makes it so that the search results aren't fucked up
    // When switching between tabs.
    // Hopefully this won't come back to bite us in the ass.
    // If it does, simply figure out which functions
    // in particular need to be within or without the IF statement.
    // ****
    
    if ( !self.searchDisplayController.isActive ) {
        [self loadFavoriteMonologuesArray];
        
        if ( self.searchDisplayController.isActive ) {
            searchResults = [MonologueMasterlist sortMonologues:searchResults];
        } else {
            favoriteMonologuesArray = [MonologueMasterlist sortMonologues:favoriteMonologuesArray];
        }
        
    }
    
    
    // This displays the amount of monologues currently in the list
    int count = (int)favoriteMonologuesArray.count;
    NSString *headerTitle = [NSString stringWithFormat:@"Digs (%d)",count];
    [self.navigationItem setTitle:headerTitle];
    
    [self reloadSearchBar];
    
    [self.tableView reloadData];
}


// Define the array that holds and lists the monologues.
-(void)loadFavoriteMonologuesArray {
    NSLog(@"Digs: Load monologues");
    
    favoriteMonologuesArray = [[NSMutableArray alloc] init];
    
    MonologueMasterlist *masterlist = [[MonologueMasterlist alloc] init];
    masterlist.array = [masterlist compileMasterlist:YES];
    favoriteMonologuesArray = masterlist.array;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Different view for search results
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    } else {
        return favoriteMonologuesArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Monologue *currentMonologue = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentMonologue = [searchResults objectAtIndex:indexPath.row];
    } else {
        currentMonologue = [favoriteMonologuesArray objectAtIndex:indexPath.row];
    }
    
    // Make sure the reuse identifier in the Prototype Cell says "cell"
    // self.tableView (as opposed to just tableView) below was crucial to stop crashing during searches
    currentMonologue.cell = [[MonologueTableViewCell alloc] init];
    MonologueTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    currentMonologue.cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    currentMonologue.cell.titleLabel.text = currentMonologue.title;    
    currentMonologue.cell.authorLabel.text = [NSString stringWithFormat:@"%@ %@",currentMonologue.authorFirst, currentMonologue.authorLast];
    currentMonologue.cell.characterLabel.text = currentMonologue.character;
    currentMonologue.cell.excerptLabel.text = currentMonologue.text;
    
    
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:0.5]];
    currentMonologue.cell.accessoryView = accessory;
    
    cell = currentMonologue.cell;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.20
                     animations: ^{
                         // Animate the views on and off the screen.
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         cell.frame = CGRectMake(-cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                         cell.alpha = 0.0f;
                         NSLog(@"in animation");
                     } completion:^(BOOL finished) {
                         [self performSegueWithIdentifier:@"segue" sender:self];
                     }];
}



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"Digs: Filter content");
    
    NSString *sep = @", ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    searchText = [searchText stringByReplacingOccurrencesOfString:@", " withString:@" "];
    NSMutableArray *array = [[searchText componentsSeparatedByCharactersInSet:set] mutableCopy];
    
    // The array splits up searchText based on dividing characters.
    // However, this split creates a new element immediately that just a "" string. This empties the search results.
    // This if statement ignores empty elements in the array, only recognizing a new element when a non-space character is entered. It's great!
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
    
    searchResults = [[favoriteMonologuesArray filteredArrayUsingPredicate:predicate] mutableCopy];
}


// This updates the search display each time the search string is altered
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"Digs: Should reload");
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

// This updates the search results in the searchDisplayController.
// Calling this is useful for when the view should be reloaded between tabs / when the filters have changed.
-(void)reloadSearchBar {
    NSLog(@"Digs: Reload search bar");
    
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
    NSLog(@"Digs: Did end search");
    
    favoriteMonologuesArray = [MonologueMasterlist sortMonologues:favoriteMonologuesArray];
    [self.tableView reloadData];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Digs: pepare for segue");
    
    // Get the new view controller using [segue destinationViewController].
    FavoriteMonologueViewController *mvc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    // What's the selected cell.
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    // indexPathForSelectedRow loads two variables into path: section and row.
    // Now we ask for just the row and set that to c.
    Monologue *c = nil;
    if ( self.searchDisplayController.active ) {
        path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        c = searchResults[path.row];
        // For swipe gesture
        mvc.detailsDataSource = [[NSArray alloc] initWithArray:searchResults];
    } else {
        path = [self.tableView indexPathForSelectedRow];
        c = favoriteMonologuesArray[path.row];
        // For swipe gesture
        mvc.detailsDataSource = [[NSArray alloc] initWithArray:favoriteMonologuesArray];

    }
    mvc.currentMonologue = c;
    // For swipe gesture
    mvc.detailIndex = path.row;
    
    // This keeps the MonologueViewController from skipping any lines in the monologue when accessed from the Browse Screen.
    mvc.edgesForExtendedLayout = UIRectEdgeNone;
    
    
}



@end
