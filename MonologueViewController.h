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
#import "YorickStyle.h"
#import "PopUpView.h"
#import "TabBarController.h"
#import "NotesTableViewCell.h"
#import "TextTableViewCell.h"

@interface MonologueViewController : UITableViewController

@property (nonatomic) Monologue *currentMonologue;

@property (nonatomic) NSMutableArray *relatedMonologues;

@property (nonatomic) TextTableViewCell *textCell;
@property (nonatomic) NotesTableViewCell *notesCell;
@property (nonatomic) UITableViewCell *tagCell;

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
-(void)setFavoriteStatus;
-(void)compileRelatedMonologuesfromArrayOfMonologues:(NSArray*)sourceMonologues;
-(NSArray*)loadTagsIntoArray:(NSString*)tags;
-(void)addTapGestureRecognizerToCell:(UITableViewCell*)cell;

@end
