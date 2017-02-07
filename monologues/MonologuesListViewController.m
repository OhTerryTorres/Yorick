//
//  FirstViewController.m
//  Yorick
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "MonologuesListViewController.h"

@interface MonologuesListViewController ()

@end

@implementation MonologuesListViewController


#pragma mark: App Delegate Access

-(void)passManagerToAppDelegate {
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    appDelegate.manager = self.manager;
}
-(void)getManagerFromAppDelegate {
    // *****
    // This should ultimately be moved to which screen is the first the user sees.
    //
    // Access Appdelegate to get our Monologue Manager
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    self.manager = appDelegate.manager;
}

#pragma mark: View Changing Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getManagerFromAppDelegate];
    
    // *****
    // This may not be necessary
    self.navigationController.tabBarController.tabBar.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    
    // Initialize the data service for this tableview.
    [self setUpDataService];
    
    // Initialize search controller
    [self setUpSearchController];
    
    [self.tableView reloadData];
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(segueByNotification:)
                                                 name:@"segueByNotification"
                                               object:self.dataService];
    
    // UI
    self.navigationController.tabBarController.tabBar.userInteractionEnabled = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    
    self.tableView.tintColor = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getManagerFromAppDelegate];
    [self updateDisplayArrayForFilters];
    [self setHeaderTitle];
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self passManagerToAppDelegate];
}


#pragma mark: Display Setup

-(void)setUpDataService {
    self.dataService = [[MonologueDataService alloc] initWithManager:self.manager andDisplayArray:self.manager.monologues];
    self.tableView.delegate = self.dataService;
    self.tableView.dataSource = self.dataService;
    self.dataService.manager = self.manager;
}

-(void)setHeaderTitle {
    NSString *headerTitle = [NSString stringWithFormat:@"%@ (%lu)",self.title, (unsigned long)self.dataService.displayArray.count];
    [self.navigationItem setTitle:headerTitle];
}

-(void)updateDisplayArrayForFilters {
    NSLog(@"Filtering based on searchString");
    if ( ![self.searchController.searchBar.text isEqualToString:@""] ) {
        self.dataService.displayArray = [self.manager filterMonologues:[self.manager filterMonologuesForSettings:self.manager.monologues] forSearchString:self.searchController.searchBar.text];
    } else {
        self.dataService.displayArray = [self.manager filterMonologuesForSettings:self.manager.monologues];
    }
}


#pragma mark: UISearchController & Notification Methods

-(void)setUpSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1.0];
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar sizeToFit];
    
    // Add the UISearchBar to the top header of the table view
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Hides search bar initially.  When the user pulls down on the list, the search bar is revealed.
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
    
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
}

// When the user types in the search bar, this method gets called.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    
    // Check if the user cancelled or deleted the search term so we can display the full list instead.
    if (![searchString isEqualToString:@""]) {
        [self.dataService.displayArray removeAllObjects];
        self.dataService.displayArray = [self.manager filterMonologues:[self.manager filterMonologuesForSettings:self.manager.monologues] forSearchString:searchString];
        self.dataService.searchActive = TRUE;
    }
    else {
        self.dataService.displayArray = [self.manager filterMonologuesForSettings:self.manager.monologues];
        self.dataService.searchActive = FALSE;
    }
    [self.tableView reloadData];
    [self setHeaderTitle];
}


// This enables the Monologue List View Controller to use the didSelectRow method from the Data Service class to perform a segue.
-(void)segueByNotification:(NSNotification*)notification {
    NSIndexPath* indexPath = [notification.userInfo objectForKey:@"indexPath"];
    [self performSegueWithIdentifier:@"segue" sender:indexPath];
}


#pragma mark: Prepare For Segue

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // This prepares the monologue to appear in the monologue screen.
    // Get the new view controller using [segue destinationViewController].
    MonologueViewController *mvc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    // What's the selected cell.
    NSIndexPath *path = sender;
    // indexPathForSelectedRow loads two variables into path: section and row.
    // Now we ask for just the row and set that to c.
    Monologue *c = nil;
    if ( self.dataService.searchActive || self.dataService.isForFavorites ) {
        c = self.dataService.displayArray[path.row];
        // For swipe gesture
        mvc.detailsDataSource = [[NSArray alloc] initWithArray:self.dataService.displayArray];
        // For swipe gesture
        mvc.detailIndex = [self.dataService.displayArray indexOfObject:c];
    } else {
        // Use the same code from cellForRowAtIndexPath to access the appropriate monologue from self.masterlist.sections
        c = [[self.dataService.sections valueForKey:[[[self.dataService.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:path.section]] objectAtIndex:path.row];
        // For swipe gesture
        mvc.detailsDataSource = [[NSArray alloc] initWithArray:self.dataService.displayArray];
        // For swipe gesture
        mvc.detailIndex = [self.dataService.displayArray indexOfObject:c];
    }
    // Make sure the manager is being passed to
    mvc.manager = self.manager;
    
    mvc.currentMonologue = c;
    
    
    // This keeps the MonologueViewController from skipping any lines in the monologue when accessed from the Browse Screen.
    mvc.edgesForExtendedLayout = UIRectEdgeNone;
    
}




@end
