//
//  FiltersViewController.h
//  monologues
//
//  Created by TerryTorres on 8/4/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTableViewCell.h"

@interface FiltersViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView *genderPicker;
    NSArray *genderArray;
    UIPickerView *tonePicker;
    NSArray *toneArray;
    UIPickerView *periodPicker;
    NSArray *periodArray;
    UIPickerView *agePicker;
    NSArray *ageArray;
    UIPickerView *lengthPicker;
    NSArray *lengthArray;
    UIPickerView *sortPicker;
    NSArray *sortArray;
    UIPickerView *sizePicker;
    NSArray *sizeArray;
    
}

@property (strong, nonatomic) IBOutlet SettingTableViewCell *genderCell;
@property (strong, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderPickerCell;
@property (nonatomic) BOOL genderPickerCellIsShowing;
@property (strong, nonatomic) NSString *genderFilter;

@property (strong, nonatomic) IBOutlet SettingTableViewCell *toneCell;
@property (strong, nonatomic) IBOutlet UIPickerView *tonePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *tonePickerCell;
@property (nonatomic) BOOL tonePickerCellIsShowing;
@property (strong, nonatomic) NSString *toneFilter;

@property (strong, nonatomic) IBOutlet SettingTableViewCell *periodCell;
@property (strong, nonatomic) IBOutlet UIPickerView *periodPicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *periodPickerCell;
@property (nonatomic) BOOL periodPickerCellIsShowing;
@property (strong, nonatomic) NSString *periodFilter;

@property (strong, nonatomic) IBOutlet SettingTableViewCell *ageCell;
@property (strong, nonatomic) IBOutlet UIPickerView *agePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *agePickerCell;
@property (nonatomic) BOOL agePickerCellIsShowing;
@property (strong, nonatomic) NSString *ageFilter;

@property (strong, nonatomic) IBOutlet SettingTableViewCell *lengthCell;
@property (strong, nonatomic) IBOutlet UIPickerView *lengthPicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *lengthPickerCell;
@property (nonatomic) BOOL lengthPickerCellIsShowing;
@property (strong, nonatomic) NSString *lengthFilter;

@property (strong, nonatomic) IBOutlet SettingTableViewCell *sortCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sortPickerCell;
@property (strong, nonatomic) IBOutlet UIPickerView *sortPicker;
@property (nonatomic) BOOL sortPickerCellIsShowing;
@property (strong, nonatomic) NSString *sortBy;

@property (strong, nonatomic) IBOutlet SettingTableViewCell *sizeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sizePickerCell;
@property (strong, nonatomic) IBOutlet UIPickerView *sizePicker;
@property (nonatomic) BOOL sizePickerCellIsShowing;
@property (strong, nonatomic) NSString *textSize;

@property (nonatomic) NSInteger genderPickerRowDefault;
@property (nonatomic) NSInteger tonePickerRowDefault;
@property (nonatomic) NSInteger periodPickerRowDefault;
@property (nonatomic) NSInteger agePickerRowDefault;
@property (nonatomic) NSInteger lengthPickerRowDefault;
@property (nonatomic) NSInteger sortPickerRowDefault;
@property (nonatomic) NSInteger sizePickerRowDefault;

@property (nonatomic) CGRect genderPickerFrame;
@property (nonatomic) CGRect tonePickerFrame;
@property (nonatomic) CGRect periodPickerFrame;
@property (nonatomic) CGRect agePickerFrame;
@property (nonatomic) CGRect lengthPickerFrame;
@property (nonatomic) CGRect sortPickerFrame;
@property (nonatomic) CGRect sizePickerFrame;

- (IBAction)clearFilters:(id)sender;


@end
