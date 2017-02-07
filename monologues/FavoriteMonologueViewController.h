//
//  FavoriteMonologueViewController.h
//  Yorick
//
//  Created by TerryTorres on 7/16/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import "TagSelectionViewController.h"
#import "MonologueViewController.h"

@interface FavoriteMonologueViewController : MonologueViewController

@property (nonatomic, strong) UYLTextCell *prototypeCellEdit;

@property (nonatomic, strong) NSArray *editArray;

- (IBAction)favoriteButtonAction:(id)sender;


@end
