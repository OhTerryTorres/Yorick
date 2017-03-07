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

@property (weak, nonatomic) MonologueManager *manager;

@property (nonatomic) Monologue *currentMonologue;

@property (nonatomic) NSMutableArray *relatedMonologues;

@property (nonatomic) NotesTableViewCell *notesCell;
@property (nonatomic) TextTableViewCell *textCell;
@property (nonatomic) NSArray *textArray;
@property (nonatomic) UITableViewCell *tagCell;
@property (nonatomic) NSArray *tagsArray;

@property (nonatomic) NSArray *detailsDataSource;
@property unsigned long detailIndex;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButtonOutlet;
- (IBAction)favoriteButtonAction:(id)sender;

-(void)addMonologueToFavorites;
-(void)swipeToNewMonologue:(Monologue*)monologue willSwipeToRight:(BOOL)swipeRight;
-(void)passManagerToAppDelegate;
-(MonologueTableViewCell*)getCellForRelatedMonologue:(Monologue*)monologue atIndexPath:(NSIndexPath*)indexPath;
-(void)setFavoriteStatus;
-(NSMutableArray*)findMonologuesRelatedToMonologue:(Monologue*)monologue inArrayOfMonologues:(NSArray*)sourceMonologues;
-(NSArray*)loadTagsIntoArray:(NSString*)tags;
-(NSArray*)splitTextIntoArray:(NSString*)text;
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
-(int)getNewDetailIndexForMonologue:(Monologue*)monologue;

@end
