//
//  FirstViewController.h
//  monologues
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monologue.h"
#import "MonologueViewController.h"
#import "AppDelegate.h"
#import "DTCustomColoredAccessory.h"
#import "MonologueMasterlist.h"
#import "SettingsViewController.h"

@interface BrowseViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) MonologueMasterlist *masterlist;

- (IBAction)showSettings:(id)sender;

@end
