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


#pragma mark: View Changing Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    
    [self loadSettings];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
}


#pragma mark: Display Setup

-(void) loadSettings {

    for (int i = 0; i < self.manager.settings.count; i++) {
        
        Setting *setting = self.manager.settings[i];
        
        setting.cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        setting.cell.titleLabel.text = [setting.title capitalizedString];
        setting.cell.settingLabel.text = setting.currentSetting;
        
        setting.cell.pickerView = [[UIPickerView alloc] init];
        [setting.cell.pickerView setShowsSelectionIndicator:false];
        setting.cell.pickerView.delegate = self;
        setting.cell.pickerView.dataSource = self;
        setting.cell.pickerView.tag = i;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
            [self pickerCellShow:setting];
        }
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

    return self.manager.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting *setting = [self.manager.settings objectAtIndex:indexPath.row];
    
    [setting.cell setNeedsUpdateConstraints];
    
    return setting.cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Setting *setting = [self.manager.settings objectAtIndex:indexPath.row];
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


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //set number of rows
    
    // Get writing the setting object by referring to the tag of the current pickerView,
    // which we generated in the while loop back at loadsettings
    Setting *setting =  [self.manager.settings objectAtIndex:pickerView.tag];

    return setting.options.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* label = (UILabel*)view;
    if (!label) {
        label = [[UILabel alloc] init];
        Setting *setting = [self.manager.settings objectAtIndex:pickerView.tag];
        
        label.text = setting.options[row];
        label.font = [YorickStyle defaultFont];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    Setting *setting = self.manager.settings[pickerView.tag];
    NSString *rowItem = [setting.options objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    setting.cell.settingLabel.text = rowItem;
    setting.currentSetting = rowItem;
    [pickerView reloadAllComponents];
    
    TabBarController* tbc = (TabBarController*)self.tabBarController;
    [tbc updateBrowseBadge];
    
}

- (void)pickerCellShow:(Setting*)setting  {
    
    setting.pickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    setting.cell.pickerView.hidden = NO;
    setting.cell.colored = YES;
    
    CGRect rect = setting.cell.pickerView.frame;
    
    rect.size.width = self.view.frame.size.width;
    rect.origin.y += 22;
    
    setting.cell.pickerView.frame = rect;
    
    setting.cell.pickerView.alpha = 0.0f;
    [setting.cell addSubview:setting.cell.pickerView];
    
    [UIView animateWithDuration:0.25 animations:^{
        setting.cell.pickerView.alpha = 1.0f;
    }];
    
    [setting.cell.pickerView selectRow:[setting indexOfCurrentSetting] inComponent:0 animated:YES];
    
}
- (void)pickerCellHide:(Setting*)setting {
    
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad ) {
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
    PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Type filters reset"];
    [self.tabBarController.view addSubview:popUp];
    TabBarController* tbc = (TabBarController*)self.tabBarController;
    [tbc updateBrowseBadge];
}


// Restore cell height
-(void)dealloc {
    for (Setting *setting in self.manager.settings) {
        setting.pickerCellIsShowing = NO;
    }
}



@end
