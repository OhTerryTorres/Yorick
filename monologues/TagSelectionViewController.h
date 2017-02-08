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
#import "YorickStyle.h"

@interface TagSelectionViewController : UITableViewController

@property (weak, nonatomic) MonologueManager *manager;
@property (nonatomic) Monologue *currentMonologue;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
