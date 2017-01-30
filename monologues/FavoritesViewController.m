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
    [super viewDidLoad];
    self.dataService.isForFavorites = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Digs";
    // This displays the amount of monologues currently in the list
    NSString *headerTitle = [NSString stringWithFormat:@"%@ (%d)",self.title, self.dataService.displayArray.count];
    [self.navigationItem setTitle:headerTitle];
    
}

-(void)updateDisplayArrayForFilters {
    NSLog(@"Filtering based on searchString");
    if ( ![self.searchController.searchBar.text isEqualToString:@""] ) {
        self.dataService.displayArray = [self.manager filterMonologues:[self.manager filterMonologuesForSettings:self.manager.favoriteMonologues] forSearchString:self.searchController.searchBar.text];
    }
    self.dataService.displayArray = [self.manager filterMonologuesForSettings:self.manager.favoriteMonologues];
    NSLog(@"self.dataService.displayArray.count is %d",self.dataService.displayArray.count);
}

-(void)setUpDataService {
    self.dataService = [[MonologueDataService alloc] initWithManager:self.manager andDisplayArray:self.manager.favoriteMonologues];
    self.tableView.delegate = self.dataService;
    self.tableView.dataSource = self.dataService;
    self.dataService.manager = self.manager;
}




@end
