//
//  MonologueListViewController.h
//  Yorick
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monologue.h"
#import "MonologueViewController.h"
#import "AppDelegate.h"
#import "DTCustomColoredAccessory.h"
#import "MonologueManager.h"
#import "MonologueDataService.h"

@interface MonologuesListViewController : UITableViewController <UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController * searchController;

@property (strong, nonatomic) MonologueManager *manager;
@property (strong, nonatomic) MonologueDataService *dataService;

@end
