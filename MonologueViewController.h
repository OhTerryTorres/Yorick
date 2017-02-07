//
//  MonologueViewController.h
//  Yorick
//
//  Created by TerryTorres on 7/7/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monologue.h"
#import "MonologueManager.h"
#import "MonologuesListViewController.h"
#import "UYLTextCell.h"

@interface MonologueViewController : UITableViewController

@property (nonatomic) Monologue *currentMonologue;

@property (nonatomic) NSMutableArray *relatedMonologues;

@property (nonatomic, strong) UYLTextCell *prototypeCellText;

@property (nonatomic, strong) UYLTextCell *prototypeCellNotes;

@property (nonatomic, strong) UYLTextCell *prototypeCellTags;

@property (strong, nonatomic) MonologueTableViewCell *prototypeCellRelated;

@property (nonatomic, strong) NSArray *tagsArray;

@property (nonatomic) CGFloat cgFloatY;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoriteButtonOutlet;

- (IBAction)favoriteButtonAction:(id)sender;

@property (strong, nonatomic) NSArray *detailsDataSource;

@property unsigned long detailIndex;

@property (strong, nonatomic) MonologueManager *manager;

@property (nonatomic) int barsHidden;


- (void)loadData;
-(void)addMonologueToFavorites;
-(void)monologueTransitionForIndexPath:(NSIndexPath*)indexPath;
-(void)maintainView;
-(void)passManagerToAppDelegate;
-(Monologue*)getRelatedMonologueForIndexPath:(NSIndexPath*)indexPath;
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
