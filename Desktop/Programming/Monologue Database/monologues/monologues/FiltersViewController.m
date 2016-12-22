//
//  FiltersViewController.m
//  monologues
//
//  Created by TerryTorres on 8/4/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@end

@implementation FiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    [self loadPickerArrays];
    [self loadFilters];
}

// Initialize arrays that will populate the pickerViews in the table.
-(void) loadPickerArrays {
    genderArray = [[NSArray alloc] initWithObjects:@"Any", @"Female", @"Male", nil];
    toneArray = [[NSArray alloc] initWithObjects:@"Any",@"Comedic", @"Dramatic", nil];
    periodArray = [[NSArray alloc] initWithObjects:@"Any", @"Classical", @"Modern", @"Contemporary", nil];
    ageArray = [[NSArray alloc] initWithObjects:@"Any", @"Child", @"Adolescent", @"Young Adult", @"Adult", @"Middle Age", @"Elder", nil];
    lengthArray = [[NSArray alloc] initWithObjects: @"Any", @"< 1 minute", @"< 2 minutes", @"< 3 minutes", nil];
    sortArray = [[NSArray alloc] initWithObjects: @"Title", @"Author", nil];
    sizeArray = [[NSArray alloc] initWithObjects: @"Normal", @"Large", @"Very Large", @"Largest", nil];
    
}

// Filter options will be loaded from user defaults.
-(void)loadFilters {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"genderFilter"] != nil) {
        self.genderFilter = [defaults objectForKey:@"genderFilter"];
        // If it's the first time, both objects are initialized.
    } else {
        self.genderFilter = [genderArray objectAtIndex:0];
    }
    self.genderCell.detailTextLabel.text = self.genderFilter;
    
    if ([defaults objectForKey:@"toneFilter"] != nil) {
        self.toneFilter = [defaults objectForKey:@"toneFilter"];
        // If it's the first time, both objects are initialized.
    } else {
        self.toneFilter = [toneArray objectAtIndex:0];
    }
    self.toneCell.detailTextLabel.text = self.toneFilter;
    
    if ([defaults objectForKey:@"periodFilter"] != nil) {
        self.periodFilter = [defaults objectForKey:@"periodFilter"];
        // If it's the first time, both objects are initialized.
    } else {
        self.periodFilter = [periodArray objectAtIndex:0];
    }
    self.periodCell.detailTextLabel.text = self.periodFilter;
    
    if ([defaults objectForKey:@"ageFilter"] != nil) {
        self.ageFilter = [defaults objectForKey:@"ageFilter"];
        // If it's the first time, both objects are initialized.
    } else {
        self.ageFilter = [ageArray objectAtIndex:0];
    }
    self.ageCell.detailTextLabel.text = self.ageFilter;
    
    if ([defaults objectForKey:@"lengthFilter"] != nil) {
        self.lengthFilter = [defaults objectForKey:@"lengthFilter"];
        // If it's the first time, both objects are initialized.
    } else {
        self.lengthFilter = [lengthArray objectAtIndex:0];
    }
    self.lengthCell.detailTextLabel.text = self.lengthFilter;
    
    if ([defaults objectForKey:@"sortBy"] != nil) {
        self.sortBy = [defaults objectForKey:@"sortBy"];
        // If it's the first time, both objects are initialized.
    } else {
        self.sortBy = [sortArray objectAtIndex:0];
    }
    self.sortCell.detailTextLabel.text = self.sortBy;
    
    if ([defaults objectForKey:@"textSize"] != nil) {
        self.textSize = [defaults objectForKey:@"textSize"];
        // If it's the first time, both objects are initialized.
    } else {
        self.textSize = [sizeArray objectAtIndex:0];
    }
    self.sizeCell.detailTextLabel.text = self.textSize;
}


// Picker Stuff
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    NSMutableArray *array = [[NSMutableArray alloc] init];

    switch ( [pickerView tag] ) {
        case 0:
            array = [genderArray mutableCopy];
            break;
        case 1:
            array = [toneArray mutableCopy];
            break;
        case 2:
            array = [periodArray mutableCopy];
            break;
        case 3:
            array = [ageArray mutableCopy];
            break;
        case 4:
            array = [lengthArray mutableCopy];
            break;
        case 5:
            array = [sortArray mutableCopy];
            break;
        case 6:
            array = [sizeArray mutableCopy];
            break;
        default:
            break;
    }
    return array.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    NSMutableArray *array = [[NSMutableArray alloc] init];
    switch ( [pickerView tag] ) {
        case 0:
            array = [genderArray mutableCopy];
            break;
        case 1:
            array = [toneArray mutableCopy];
            break;
        case 2:
            array = [periodArray mutableCopy];
            break;
        case 3:
            array = [ageArray mutableCopy];
            break;
        case 4:
            array = [lengthArray mutableCopy];
            break;
        case 5:
            array = [sortArray mutableCopy];
            break;
        case 6:
            array = [sizeArray mutableCopy];
            break;
        default:
            break;
    }
    return [array objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([pickerView tag] == 0) {
        self.genderFilter = [genderArray objectAtIndex:[self.genderPicker selectedRowInComponent:0]];
        self.genderCell.detailTextLabel.text = [genderArray objectAtIndex:[self.genderPicker selectedRowInComponent:0]];
        [defaults setObject:self.genderFilter forKey:@"genderFilter"];
        
        self.genderPickerRowDefault = [pickerView selectedRowInComponent:0];
        [defaults setInteger:self.genderPickerRowDefault forKey:@"genderPickerRowDefault"];
        
    }
    if ([pickerView tag] == 1) {
        self.toneFilter = [toneArray objectAtIndex:[self.tonePicker selectedRowInComponent:0]];
        self.toneCell.detailTextLabel.text = [toneArray objectAtIndex:[self.tonePicker selectedRowInComponent:0]];
        [defaults setObject:self.toneFilter forKey:@"toneFilter"];
        
        self.tonePickerRowDefault = [pickerView selectedRowInComponent:0];
        [defaults setInteger:self.tonePickerRowDefault forKey:@"tonePickerRowDefault"];
        
        NSLog(@"toneFiler is %@",self.toneFilter);
    }
    if ([pickerView tag] == 2) {
        self.periodFilter = [periodArray objectAtIndex:[self.periodPicker selectedRowInComponent:0]];
        self.periodCell.detailTextLabel.text = [periodArray objectAtIndex:[self.periodPicker selectedRowInComponent:0]];
        [defaults setObject:self.periodFilter forKey:@"periodFilter"];
        
        self.periodPickerRowDefault = [pickerView selectedRowInComponent:0];
        [defaults setInteger:self.periodPickerRowDefault forKey:@"periodPickerRowDefault"];
        
        NSLog(@"periodFiler is %@",self.periodFilter);
    }
    if ([pickerView tag] == 3) {
        self.ageFilter = [ageArray objectAtIndex:[self.agePicker selectedRowInComponent:0]];
        self.ageCell.detailTextLabel.text = [ageArray objectAtIndex:[self.agePicker selectedRowInComponent:0]];
        [defaults setObject:self.ageFilter forKey:@"ageFilter"];
        
        self.agePickerRowDefault = [pickerView selectedRowInComponent:0];
        [defaults setInteger:self.agePickerRowDefault forKey:@"agePickerRowDefault"];
        
        NSLog(@"ageFiler is %@",self.ageFilter);
    }
    if ([pickerView tag] == 4) {
        self.lengthFilter = [lengthArray objectAtIndex:[self.lengthPicker selectedRowInComponent:0]];
        self.lengthCell.detailTextLabel.text = [lengthArray objectAtIndex:[self.lengthPicker selectedRowInComponent:0]];
        [defaults setObject:self.lengthFilter forKey:@"lengthFilter"];
        
        self.lengthPickerRowDefault = [pickerView selectedRowInComponent:0];
        [defaults setInteger:self.lengthPickerRowDefault forKey:@"lengthPickerRowDefault"];
        
        NSLog(@"lengthFiler is %@",self.lengthFilter);
    }
    if ([pickerView tag] == 5) {
        self.sortBy = [sortArray objectAtIndex:[self.sortPicker selectedRowInComponent:0]];
        self.sortCell.detailTextLabel.text = [sortArray objectAtIndex:[self.sortPicker selectedRowInComponent:0]];
        [defaults setObject:self.sortBy forKey:@"sortBy"];
        
        self.sortPickerRowDefault = [pickerView selectedRowInComponent:0];
        [defaults setInteger:self.sortPickerRowDefault forKey:@"sortPickerRowDefault"];
        
        NSLog(@"sortBy is %@",self.sortBy);
    }
    if ([pickerView tag] == 6) {
        self.textSize = [sizeArray objectAtIndex:[self.sizePicker selectedRowInComponent:0]];
        self.sizeCell.detailTextLabel.text = [sizeArray objectAtIndex:[self.sizePicker selectedRowInComponent:0]];
        [defaults setObject:self.textSize forKey:@"textSize"];
        
        self.sizePickerRowDefault = [pickerView selectedRowInComponent:0];
        [defaults setInteger:self.sizePickerRowDefault forKey:@"sizePickerRowDefault"];
        
        NSLog(@"textSize is %@",self.textSize);
    }
}


// pickerView operational stuff (appearing, disappearing)

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.tableView.rowHeight;
    if ( indexPath.section == 0 && indexPath.row == 1){
        height = self.genderPickerCellIsShowing ? 125 : 0.0f;
    }
    if ( indexPath.section == 0 && indexPath.row == 3){
        height = self.tonePickerCellIsShowing ? 125 : 0.0f;
    }
    if ( indexPath.section == 0 && indexPath.row == 5){
        height = self.periodPickerCellIsShowing ? 125 : 0.0f;
    }
    if ( indexPath.section == 0 && indexPath.row == 7){
        height = self.agePickerCellIsShowing ? 125 : 0.0f;
    }
    if ( indexPath.section == 0 && indexPath.row == 9){
        height = self.lengthPickerCellIsShowing ? 125 : 0.0f;
    }
    if ( indexPath.section == 1 && indexPath.row == 1){
        height = self.sortPickerCellIsShowing ? 125 : 0.0f;
    }
    if ( indexPath.section == 1 && indexPath.row == 3){
        height = self.sizePickerCellIsShowing ? 125 : 0.0f;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0){
        if (self.genderPickerCellIsShowing){
            [self genderPickerCellHide];
        } else {
            [self genderPickerCellShow];
            [self tonePickerCellHide];
            [self periodPickerCellHide];
            [self agePickerCellHide];
            [self lengthPickerCellHide];
            [self sortPickerCellHide];
            [self sizePickerCellHide];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 2){
        if (self.tonePickerCellIsShowing){
            [self tonePickerCellHide];
        } else {
            [self tonePickerCellShow];
            [self genderPickerCellHide];
            [self periodPickerCellHide];
            [self agePickerCellHide];
            [self lengthPickerCellHide];
            [self sortPickerCellHide];
            [self sizePickerCellHide];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 4){
        if (self.periodPickerCellIsShowing){
            [self periodPickerCellHide];
        } else {
            [self periodPickerCellShow];
            [self genderPickerCellHide];
            [self tonePickerCellHide];
            [self agePickerCellHide];
            [self lengthPickerCellHide];
            [self sortPickerCellHide];
            [self sizePickerCellHide];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 6){
        if (self.agePickerCellIsShowing){
            [self agePickerCellHide];
        } else {
            [self agePickerCellShow];
            [self genderPickerCellHide];
            [self tonePickerCellHide];
            [self periodPickerCellHide];
            [self lengthPickerCellHide];
            [self sortPickerCellHide];
            [self sizePickerCellHide];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 8){
        if (self.lengthPickerCellIsShowing){
            [self lengthPickerCellHide];
        } else {
            [self lengthPickerCellShow];
            [self genderPickerCellHide];
            [self tonePickerCellHide];
            [self periodPickerCellHide];
            [self agePickerCellHide];
            [self sortPickerCellHide];
            [self sizePickerCellHide];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0){
        if (self.sortPickerCellIsShowing){
            [self sortPickerCellHide];
        } else {
            [self sortPickerCellShow];
            [self genderPickerCellHide];
            [self tonePickerCellHide];
            [self periodPickerCellHide];
            [self agePickerCellHide];
            [self lengthPickerCellHide];
            [self sizePickerCellHide];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 2){
        if (self.sizePickerCellIsShowing){
            [self sizePickerCellHide];
        } else {
            [self sizePickerCellShow];
            [self genderPickerCellHide];
            [self tonePickerCellHide];
            [self periodPickerCellHide];
            [self agePickerCellHide];
            [self lengthPickerCellHide];
            [self sortPickerCellHide];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)genderPickerCellShow {
    self.genderPickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.genderPicker.hidden = NO;
    
    // An attempt to center the picker within the view cell
    CGRect rect = self.genderPicker.frame;
    rect.origin.y = (self.genderPicker.frame.size.height * .15) * -1;
    self.genderPicker.frame = rect;
    
    self.genderPicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.genderPicker.alpha = 1.0f;
    }];
    self.genderCell.colored = YES;
    
    self.genderPickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:@"genderPickerRowDefault"];
    [self.genderPicker selectRow:self.genderPickerRowDefault inComponent:0 animated:YES];
    
    NSLog(@"Gender show");
}
- (void)genderPickerCellHide {
    self.genderCell.colored = NO;
    self.genderCell.detailTextLabel.textColor = [UIColor grayColor];
    self.genderPickerCellIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.genderPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.genderPicker.hidden = YES;
                     }];
    
    NSLog(@"Gender hide");
    
}



- (void)tonePickerCellShow {
    self.tonePickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.tonePicker.hidden = NO;
    
    // An attempt to center the picker within the view cell
    CGRect rect = self.tonePicker.frame;
    rect.origin.y = (self.tonePicker.frame.size.height * .15) * -1;
    self.tonePicker.frame = rect;
    
    self.tonePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.tonePicker.alpha = 1.0f;
    }];
    self.toneCell.colored = YES;

    self.tonePickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:@"tonePickerRowDefault"];
    [self.tonePicker selectRow:self.tonePickerRowDefault inComponent:0 animated:YES];
    
}
- (void)tonePickerCellHide {
    self.tonePickerCellIsShowing = NO;
    self.toneCell.detailTextLabel.textColor = [UIColor grayColor];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.toneCell.colored = NO;

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.tonePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.tonePicker.hidden = YES;
                     }];
}



- (void)periodPickerCellShow {
    self.periodPickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.periodPicker.hidden = NO;
    
    // An attempt to center the picker within the view cell
    CGRect rect = self.periodPicker.frame;
    rect.origin.y = (self.periodPicker.frame.size.height * .15) * -1;
    self.periodPicker.frame = rect;
    
    self.periodPicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.periodPicker.alpha = 1.0f;
    }];
    self.periodCell.colored = YES;

    
    self.periodPickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:@"periodPickerRowDefault"];
    [self.periodPicker selectRow:self.periodPickerRowDefault inComponent:0 animated:YES];
    
}
- (void)periodPickerCellHide {
    self.periodPickerCellIsShowing = NO;
    self.periodCell.detailTextLabel.textColor = [UIColor grayColor];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.periodCell.colored = NO;

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.periodPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.periodPicker.hidden = YES;
                     }];
}



- (void)agePickerCellShow {
    self.agePickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.agePicker.hidden = NO;
    
    // An attempt to center the picker within the view cell
    CGRect rect = self.agePicker.frame;
    rect.origin.y = (self.agePicker.frame.size.height * .15) * -1;
    self.agePicker.frame = rect;
    
    self.agePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.agePicker.alpha = 1.0f;
    }];
    self.ageCell.colored = YES;

    
    self.agePickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:@"agePickerRowDefault"];
    [self.agePicker selectRow:self.agePickerRowDefault inComponent:0 animated:YES];
}
- (void)agePickerCellHide {
    self.agePickerCellIsShowing = NO;
    self.ageCell.detailTextLabel.textColor = [UIColor grayColor];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.ageCell.colored = NO;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.agePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.agePicker.hidden = YES;
                     }];
}



- (void)lengthPickerCellShow {
    self.lengthPickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.lengthPicker.hidden = NO;
    
    // An attempt to center the picker within the view cell
    CGRect rect = self.lengthPicker.frame;
    rect.origin.y = (self.lengthPicker.frame.size.height * .15) * -1;
    self.lengthPicker.frame = rect;
    
    self.lengthPicker.alpha = 0.0f;
    self.lengthCell.colored = YES;

    [UIView animateWithDuration:0.25 animations:^{
        self.lengthPicker.alpha = 1.0f;
    }];
    
    self.lengthPickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:@"lengthPickerRowDefault"];
    [self.lengthPicker selectRow:self.lengthPickerRowDefault inComponent:0 animated:YES];
}
- (void)lengthPickerCellHide {
    self.lengthPickerCellIsShowing = NO;
    self.lengthCell.detailTextLabel.textColor = [UIColor grayColor];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.lengthCell.colored = NO;

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.lengthPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.lengthPicker.hidden = YES;
                     }];
}




- (void)sortPickerCellShow {
    self.sortPickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.sortPicker.hidden = NO;
    
    // An attempt to center the picker within the view cell
    CGRect rect = self.sortPicker.frame;
    rect.origin.y = (self.sortPicker.frame.size.height * .15) * -1;
    self.sortPicker.frame = rect;
    
    self.sortPicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.sortPicker.alpha = 1.0f;
    }];
    self.sortCell.colored = YES;

    
    self.sortPickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:@"sortPickerRowDefault"];
    [self.sortPicker selectRow:self.sortPickerRowDefault inComponent:0 animated:YES];
}
- (void)sortPickerCellHide {
    self.sortPickerCellIsShowing = NO;
    self.sortCell.detailTextLabel.textColor = [UIColor grayColor];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.sortCell.colored = NO;

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.sortPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.sortPicker.hidden = YES;
                     }];
}



- (void)sizePickerCellShow {
    self.sizePickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.sizePicker.hidden = NO;
    
    // An attempt to center the picker within the view cell
    CGRect rect = self.sizePicker.frame;
    rect.origin.y = (self.sizePicker.frame.size.height * .15) * -1;
    self.sizePicker.frame = rect;
    
    self.sizePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.sizePicker.alpha = 1.0f;
    }];
    self.sizeCell.colored = YES;

    
    self.sizePickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:@"sizePickerRowDefault"];
    [self.sizePicker selectRow:self.sizePickerRowDefault inComponent:0 animated:YES];
}
- (void)sizePickerCellHide {
    self.sizePickerCellIsShowing = NO;
    self.sizeCell.detailTextLabel.textColor = [UIColor grayColor];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.sizeCell.colored = NO;

    [UIView animateWithDuration:0.25
                     animations:^{
                         self.sizePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.sizePicker.hidden = YES;
                     }];
}


- (IBAction)clearFilters:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Any" forKey:@"genderFilter"];
    [self.genderPicker selectRow:0 inComponent:0 animated:YES];
    [defaults setInteger:0 forKey:@"genderPickerRowDefault"];
    self.genderCell.detailTextLabel.text = @"Any";
    
    
    [defaults setObject:@"Any" forKey:@"toneFilter"];
    [self.tonePicker selectRow:self.tonePickerRowDefault inComponent:0 animated:YES];
    [defaults setInteger:0 forKey:@"tonePickerRowDefault"];
    self.toneCell.detailTextLabel.text = @"Any";

    
    [defaults setObject:@"Any" forKey:@"periodFilter"];
    [self.periodPicker selectRow:self.periodPickerRowDefault inComponent:0 animated:YES];
    [defaults setInteger:0 forKey:@"periodPickerRowDefault"];
    self.periodCell.detailTextLabel.text = @"Any";
    
    
    [defaults setObject:@"Any" forKey:@"ageFilter"];
    [self.agePicker selectRow:self.agePickerRowDefault inComponent:0 animated:YES];
    [defaults setInteger:0 forKey:@"agePickerRowDefault"];
    self.ageCell.detailTextLabel.text = @"Any";
    
    
    [defaults setObject:@"Any" forKey:@"lengthFilter"];
    [self.lengthPicker selectRow:self.lengthPickerRowDefault inComponent:0 animated:YES];
    [defaults setInteger:0 forKey:@"lengthPickerRowDefault"];
    self.lengthCell.detailTextLabel.text = @"Any";
    
    
    [defaults setObject:@"Title" forKey:@"sortBy"];
    [self.sortPicker selectRow:self.sortPickerRowDefault inComponent:0 animated:YES];
    [defaults setInteger:0 forKey:@"sortPickerRowDefault"];
    
    
    [defaults setObject:@"Normal" forKey:@"textSize"];
    [self.sizePicker selectRow:self.sizePickerRowDefault inComponent:0 animated:YES];
    [defaults setInteger:0 forKey:@"sizePickerRowDefault"];
    self.sizeCell.detailTextLabel.text = @"Normal";
    
    
    [self genderPickerCellHide];
    [self tonePickerCellHide];
    [self periodPickerCellHide];
    [self agePickerCellHide];
    [self lengthPickerCellHide];
    [self sortPickerCellHide];
    [self sizePickerCellHide];
    [self.tableView reloadData];
    [defaults synchronize];
}


// This changes the color of each section header
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //view.tintColor = [UIColor colorWithRed:183.0/255.0 green:172.0/255.0 blue:167.0/255.0 alpha:1.0];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    //[header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    header.contentView.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:0.5];
}


// Refreshes data, if needed
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self maintainView];
    
}

-(void)maintainView {
    // This remembers the y value of the monologue screen even between tabs, so it doesn't flip out or reload improperly
    [UIView animateWithDuration:0.25 animations:^{

        
    } completion:^(BOOL finished) {
        self.genderPicker.frame = self.genderPickerFrame;
        self.tonePicker.frame = self.tonePickerFrame;
        self.periodPicker.frame = self.periodPickerFrame;
        self.agePicker.frame = self.agePickerFrame;
        self.lengthPicker.frame = self.lengthPickerFrame;
        self.sortPicker.frame = self.sortPickerFrame;
        self.sizePicker.frame = self.sizePickerFrame;
        
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    self.genderPickerFrame = self.genderPicker.frame;
    self.tonePickerFrame = self.tonePicker.frame;
    self.periodPickerFrame = self.periodPicker.frame;
    self.agePickerFrame = self.agePicker.frame;
    self.lengthPickerFrame = self.lengthPicker.frame;
    self.sortPickerFrame = self.sortPicker.frame;
    self.sizePickerFrame = self.sizePicker.frame;
}



@end
