//
//  TagSearchController.h
//  Yorick
//
//  Created by TerryTorres on 3/3/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MonologueManager.h"
#import "PopUpView.h"
#import "TabBarController.h"

@interface TagSearchController : UITableViewController

@property (weak, nonatomic) MonologueManager* manager;
@property (strong, nonatomic) NSMutableDictionary *sections;

-(NSMutableDictionary*)getAlphabeticalSections:(NSMutableArray*)tags;

@end
