//
//  Setting.h
//  Yorick
//
//  Created by TerryTorres on 3/17/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SettingTableViewCell.h"

@interface Setting : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *currentSetting;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) SettingTableViewCell *cell;
@property (nonatomic) BOOL pickerCellIsShowing;

-(id)initWithTitle:(NSString*)title;
-(int)indexOfCurrentSetting;

@end
