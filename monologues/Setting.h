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

@property (strong, nonatomic) NSArray *settings;
@property (strong, nonatomic) SettingTableViewCell *cell;
@property (nonatomic) NSInteger pickerRowDefault;
@property (nonatomic) CGRect maintainFrame;
@property (nonatomic) BOOL pickerCellIsShowing;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *currentSetting;
@property (strong, nonatomic) NSString *defaultSetting;

@end
