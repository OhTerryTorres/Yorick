//
//  TagSelectionViewController.h
//  Yorick
//
//  Created by TerryTorres on 5/14/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monologue.h"
#import "FavoriteMonologueViewController.h"

@interface TagSelectionViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *allTags;
@property (strong,nonatomic) Monologue *currentMonologue;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
