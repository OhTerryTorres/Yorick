//
//  MonologueDataService.h
//  Yorick
//
//  Created by TerryTorres on 1/24/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MonologueManager.h"
#import "YorickStyle.h"

@interface MonologueDataService : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MonologueManager* manager;

// This may not need to be mutable?
@property (nonatomic, strong) NSArray *displayArray;

// These alter how the table is displayed.
@property (nonatomic) BOOL searchActive;
@property (nonatomic) BOOL isForFavorites;

@property (strong, nonatomic) NSMutableDictionary *sections;


-(id)initWithManager:(MonologueManager*)manager andDisplayArray:(NSArray*)displayArray;
-(NSMutableDictionary*)getAlphabeticalSections:(NSArray*)monologuesArray;

@end
