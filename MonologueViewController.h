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
#import "YorickStyle.h"

@interface MonologueViewController : UITableViewController

@property (nonatomic) Monologue *currentMonologue;

@property (nonatomic) NSMutableArray *relatedMonologues;

@property (nonatomic) UYLTextCell *prototypeCellText;

@property (nonatomic) UYLTextCell *prototypeCellNotes;

@property (nonatomic) UYLTextCell *prototypeCellTags;

@property (nonatomic) MonologueTableViewCell *prototypeCellRelated;

@property (nonatomic) NSArray *tagsArray;

@property (nonatomic) CGFloat cgFloatY;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButtonOutlet;

- (IBAction)favoriteButtonAction:(id)sender;

@property (nonatomic) NSArray *detailsDataSource;

@property unsigned long detailIndex;

@property (weak, nonatomic) MonologueManager *manager;

@property (nonatomic) int barsHidden;


- (void)loadData;
-(void)addMonologueToFavorites;
-(void)monologueTransitionForIndexPath:(NSIndexPath*)indexPath;
-(void)maintainView;
-(void)passManagerToAppDelegate;
-(Monologue*)getRelatedMonologueForIndexPath:(NSIndexPath*)indexPath;
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)setFavoriteStatus;
-(void)compileRelatedMonologuesfromArrayOfMonologues:(NSArray*)sourceMonologues;
-(NSArray*)loadTagsIntoArray:(NSString*)tags;

@end
