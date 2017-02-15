//
//  FavoritesViewController.m
//  Yorick
//
//  Created by TerryTorres on 7/15/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

#pragma mark: OVERRIDING SUPERCLASS METHODS

- (void)viewDidLoad
{
    self.title = @"Digs";
    [super viewDidLoad];
    self.dataService.isForFavorites = YES;
}


-(void)updateDisplayArrayForFilters {
    NSLog(@"Filtering based on searchString");
    if ( ![self.searchController.searchBar.text isEqualToString:@""] ) {
        self.dataService.displayArray = [self.manager filterMonologues: self.manager.favoriteMonologues forSearchString:self.searchController.searchBar.text];
    } else {
        self.dataService.displayArray = self.manager.favoriteMonologues;
    }
    NSLog(@"self.dataService.displayArray.count is %lu",(unsigned long)self.dataService.displayArray.count);
}

-(void)setUpDataService {
    self.dataService = [[MonologueDataService alloc] initWithManager:self.manager andDisplayArray:self.manager.favoriteMonologues];
    self.tableView.delegate = self.dataService;
    self.tableView.dataSource = self.dataService;
    self.dataService.manager = self.manager;
}

// When the user types in the search bar, this method gets called.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *searchString = searchController.searchBar.text;
        
        // Check if the user cancelled or deleted the search term so we can display the full list instead.
        if (![searchString isEqualToString:@""]) {
            self.dataService.displayArray = [self.manager filterMonologues:self.manager.favoriteMonologues forSearchString:searchString];
            self.dataService.searchActive = TRUE;
        }
        else {
            self.dataService.displayArray = self.manager.favoriteMonologues;
            self.dataService.searchActive = FALSE;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}



@end
