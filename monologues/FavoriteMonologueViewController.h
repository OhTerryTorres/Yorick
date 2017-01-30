//
//  FavoriteMonologueViewController.h
//  Yorick
//
//  Created by TerryTorres on 7/16/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monologue.h"
#import "BrowseViewController.h"
#import "UYLTextCell.h"
#import "AppDelegate.h"
#import "EditViewController.h"
#import "MonologueMasterlist.h"
#import "TagSelectionViewController.h"

@interface FavoriteMonologueViewController : UITableViewController

@property (nonatomic) Monologue *currentMonologue;

@property (nonatomic, strong) UYLTextCell *prototypeCellText;

@property (nonatomic, strong) UYLTextCell *prototypeCellNotes;

@property (nonatomic, strong) UYLTextCell *prototypeCellTags;

@property (nonatomic, strong) UYLTextCell *prototypeCellEdit;

@property (strong, nonatomic) MonologueTableViewCell *prototypeCellRelated;

@property (nonatomic, strong) NSArray *tagsArray;

@property (nonatomic, strong) NSArray *editArray;

@property (nonatomic) CGFloat cgFloatY;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoriteButtonOutlet;

- (IBAction)favoriteButtonAction:(id)sender;

@property (strong, nonatomic) NSArray *detailsDataSource;

@property unsigned long detailIndex;

@property (strong, nonatomic) MonologueMasterlist *masterlist;

@property (nonatomic) int barsHidden;


@end
