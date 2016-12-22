//
//  FavoritesViewController.h
//  monologues
//
//  Created by TerryTorres on 7/15/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monologue.h"
#import "FavoriteMonologueViewController.h"
#import "AppDelegate.h"
#import "DTCustomColoredAccessory.h"
#import "MonologueMasterlist.h"

@interface FavoritesViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
