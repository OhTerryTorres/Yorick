//
//  SettingsViewController.m
//  Yorick
//
//  Created by TerryTorres on 3/17/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController


#pragma mark: App Delegate Access

-(void)passManagerToAppDelegate {
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    appDelegate.manager = self.manager;
}
-(void)getManagerFromAppDelegate {
    // *****
    // This should ultimately be moved to which screen is the first the user sees.
    //
    // Access Appdelegate to get our Monologue Manager
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    self.manager = appDelegate.manager;
}


#pragma mark: View Changing Methods

- (void)viewDidLoad
{
    [self getManagerFromAppDelegate];
    self.title = @"Settings";
    
    [self loadSettings];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getManagerFromAppDelegate];
}
- (void) viewWillDisappear:(BOOL)animated {
    [self passManagerToAppDelegate];
}

#pragma mark: Display Setup

-(void) loadSettings {
    //self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // Here, we'll attempt to load all of the values of each setting
    int i = 0;
    while ( i < self.manager.settings.count )  {
        
        Setting *setting = self.manager.settings[i];
        
        setting.cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        setting.cell.titleLabel.text = [setting.title capitalizedString];
        setting.cell.settingLabel.text = setting.currentSetting;
        
        // **********
        // This block exists for the reformatting of particular visual settings.
        // If any settings are added or removed, this should be changed.
        // **********
        if ( [setting.title isEqualToString:@"size"] ) {
            setting.cell.titleLabel.text = @"Text Size";

            UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
            separatorLineView.backgroundColor = [YorickStyle color1];
            [setting.cell.contentView addSubview:separatorLineView];
        }
        
        setting.cell.pickerView = [[UIPickerView alloc] init];
        [setting.cell.pickerView setShowsSelectionIndicator:false];
        setting.cell.pickerView.delegate = self;
        setting.cell.pickerView.dataSource = self;
        setting.cell.pickerView.tag = i;
        setting.maintainFrame = setting.cell.pickerView.frame;
        
        i++;
    }
}


#pragma mark: TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.manager.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting *setting = [self.manager.settings objectAtIndex:indexPath.row];

    [setting.cell setNeedsUpdateConstraints];
    
    return setting.cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Setting *setting = nil;
    setting = [self.manager.settings objectAtIndex:indexPath.row];
    CGFloat height = setting.pickerCellIsShowing ? setting.cell.pickerView.frame.size.height : self.tableView.rowHeight;

    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Setting *setting = self.manager.settings[indexPath.row];
    if ( setting.pickerCellIsShowing ) {
        [self pickerCellHide:setting];
    } else {
        
        for ( int i = 0; i < self.manager.settings.count; i++) {
            setting = self.manager.settings[i];
            if ( self.manager.settings[i] == self.manager.settings[indexPath.row] ) {
                [self pickerCellShow:setting];
            } else {
                [self pickerCellHide:setting];
            }
        }
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark: PickerView Methods

// Picker Stuff
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    
    // Get writting the setting object by referring to the tag of the current pickerView,
    // which we generated in the while loop back at loadsettings
    Setting *setting =  [self.manager.settings objectAtIndex:pickerView.tag];
    
    NSMutableArray *array = [setting.options mutableCopy];
    
    return array.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    
    Setting *setting = [self.manager.settings objectAtIndex:pickerView.tag];
    return setting.options[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //
    // There could be some confustion as to when to use "picker" or "setting.picker" here
    
    Setting *setting = self.manager.settings[pickerView.tag];
    setting.currentSetting = [setting.options objectAtIndex:[pickerView selectedRowInComponent:0]];
    setting.cell.settingLabel.text = [setting.options objectAtIndex:[pickerView selectedRowInComponent:0]];
}

- (void)pickerCellShow:(Setting*)setting  {
    
    setting.pickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    setting.cell.pickerView.hidden = NO;
    setting.cell.colored = YES;
    
    CGRect rect = setting.maintainFrame;
    
    // This makes sure that the picker is wide enough for iPad.
    rect.size.width = self.view.frame.size.width;
    
    //rect.size.height = rect.size.height * 3;
    rect.origin.y += 22;
    
    setting.cell.pickerView.frame = rect;
    
    [setting.cell addSubview:setting.cell.pickerView];
    
    setting.cell.pickerView.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        setting.cell.pickerView.alpha = 1.0f;
    }];
    
    [setting.cell.pickerView selectRow:[setting indexOfCurrentSetting] inComponent:0 animated:YES];
    
}
- (void)pickerCellHide:(Setting*)setting {
    
    setting.cell.colored = NO;
    setting.pickerCellIsShowing = NO;
    [setting.cell.pickerView removeFromSuperview];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         setting.cell.pickerView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         setting.cell.pickerView.hidden = YES;
                     }];
    
}

- (IBAction)clearSettings:(id)sender {
    int i = 0;
    while (i < self.manager.settings.count) {
        Setting *setting = self.manager.settings[i];
        setting.currentSetting = setting.options[0];
        setting.cell.settingLabel.text = setting.currentSetting;
        [self pickerCellHide:setting];
        
        i++;
    }
    [self.tableView reloadData];
}


@end
