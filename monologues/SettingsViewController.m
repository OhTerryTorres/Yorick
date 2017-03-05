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

    for (int i = 0; i < self.manager.settings.count; i++) {
        
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
        if ( [setting.title isEqualToString:@"gender"] ) {
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
    // Return the number of rows in the section.
    // + 1 for TAG SEARCH!!
    return self.manager.settings.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This method will add a special row at the top that takes the user to the tag search screen.
    // As a result, the other rows will be off by one
    if ( indexPath.row == 0 ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagSearch"];
        cell.textLabel.text = @"Tag Search";
        cell.textLabel.textColor = [YorickStyle color2];
        return cell;
    } else {
        Setting *setting = [self.manager.settings objectAtIndex:indexPath.row-1];
        
        [setting.cell setNeedsUpdateConstraints];
        
        return setting.cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == 0 ) {
        return tableView.rowHeight;
    } else {
        Setting *setting = [self.manager.settings objectAtIndex:indexPath.row-1];
        CGFloat height = setting.pickerCellIsShowing ? setting.cell.pickerView.frame.size.height : self.tableView.rowHeight;
        
        return height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == 0 ) {
        
    } else{
        Setting *setting = self.manager.settings[indexPath.row-1];
        if ( setting.pickerCellIsShowing ) {
            [self pickerCellHide:setting];
        } else {
            
            for ( int i = 0; i < self.manager.settings.count; i++) {
                setting = self.manager.settings[i];
                if ( self.manager.settings[i] == self.manager.settings[indexPath.row-1] ) {
                    [self pickerCellShow:setting];
                } else {
                    [self pickerCellHide:setting];
                }
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
    
}

- (void)pickerCellShow:(Setting*)setting  {
    
    setting.pickerCellIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    setting.cell.pickerView.hidden = NO;
    setting.cell.colored = YES;
    
    CGRect rect = setting.maintainFrame;
    
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
    
    // Clear active tags
    [self.manager.activeTags removeAllObjects];
    [self.tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TagSearchController* tsc = [segue destinationViewController];
    tsc.manager = self.manager;
}

@end
