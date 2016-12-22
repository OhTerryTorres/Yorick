//
//  MonologueViewController.h
//  monologues
//
//  Created by TerryTorres on 7/7/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monologue.h"
#import "BrowseViewController.h"
#import "UYLTextCell.h"
#import "AppDelegate.h"
#import "MonologueMasterlist.h"

@interface MonologueViewController : UITableViewController

@property (nonatomic) Monologue *currentMonologue;

@property (nonatomic, strong) UYLTextCell *prototypeCellText;

@property (nonatomic, strong) UYLTextCell *prototypeCellNotes;

@property (nonatomic, strong) UYLTextCell *prototypeCellTags;

@property (strong, nonatomic) MonologueTableViewCell *prototypeCellRelated;

@property (nonatomic, strong) NSArray *tagsArray;

@property (nonatomic) CGFloat cgFloatY;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoriteButtonOutlet;

- (IBAction)favoriteButtonAction:(id)sender;

@property (strong, nonatomic) NSArray *detailsDataSource;

@property int detailIndex;

@property (strong, nonatomic) MonologueMasterlist *masterlist;

@property (nonatomic) int barsHidden;


@end
