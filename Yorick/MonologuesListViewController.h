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
#import "MonologueManager.h"
#import "MonologueDataService.h"
#import "YorickStyle.h"

@interface MonologuesListViewController : UITableViewController <UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController * searchController;

// App Delegate will always have a reference to the manager, so let's keep this relatioship weak
@property (weak, nonatomic) MonologueManager *manager;
@property (strong, nonatomic) MonologueDataService *dataService;

-(void)setUpHeaderTitle;
-(void)updateDisplayArrayForFilters;

@end
