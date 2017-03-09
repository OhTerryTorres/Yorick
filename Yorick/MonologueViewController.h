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

@property (nonatomic) UIBarButtonItem *favoriteButton;

-(void)addMonologueToFavorites;
-(void)updateData2;

-(MonologueTableViewCell*)getCellForRelatedMonologue:(Monologue*)monologue atIndexPath:(NSIndexPath*)indexPath;
-(NSMutableArray*)findMonologuesRelatedToMonologue:(Monologue*)monologue inArrayOfMonologues:(NSArray*)sourceMonologues;

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSArray*)splitTextIntoArray:(NSString*)text;

-(void)loadRelatedMonologueForIndexPath:(NSIndexPath*)indexPath;

-(CGSize)sizeForTextCellAtIndexPath:(NSIndexPath*)indexPath;
-(CGSize)sizeForNotesCellAtIndexPath:(NSIndexPath*)indexPath;
-(CGSize)sizeForTagsCellAtIndexPath:(NSIndexPath*)indexPath;

@end
