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
    // Tag Selection
    // Add a gesture recognizer to the TAGS picker
    Setting *setting = [self.manager.settings objectAtIndex:pickerView.tag];
    if ( [setting.title isEqualToString:@"tags"] ) {
        if (pickerView.gestureRecognizers.count < 1) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagSelect:)];
            tapGestureRecognizer.delegate = self;
            tapGestureRecognizer.numberOfTapsRequired = 1;
            tapGestureRecognizer.numberOfTouchesRequired = 1;
            [pickerView addGestureRecognizer:tapGestureRecognizer];
            pickerView.userInteractionEnabled = true;
        }
    }
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
        
        // Tag selection
        // Differentiate ACTIVE TAGS from other tags
        if ( [setting.title isEqualToString:@"tags"] ) {
            if ( [self.manager.activeTags containsObject: setting.options[row]] ) {
                label.text = [NSString stringWithFormat:@"[%@]", setting.options[row]];
            } else {
                label.text = setting.options[row];
            }
        }
        
        label.font = [YorickStyle defaultFont];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    return label;
}

// This allows tag select to work.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

- (void) tagSelect:(id*) sender {
    // Tag selection
    Setting *setting = self.manager.settings[3];
    NSString *currentTag = [setting.options objectAtIndex:[setting.cell.pickerView selectedRowInComponent:0]];
    if ( [self.manager.activeTags containsObject: currentTag] ) {
        [self.manager.activeTags removeObject: currentTag];
    } else {
        [self.manager.activeTags addObject: currentTag];
    }
    setting.cell.settingLabel.text = [NSString stringWithFormat:@"%d",self.manager.activeTags.count];
    [setting.cell.pickerView reloadComponent:0];
    NSLog(@"%@ selected", currentTag);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    Setting *setting = self.manager.settings[pickerView.tag];
    NSString *rowItem = [setting.options objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    // Tag selection
    if ( [setting.title isEqualToString:@"tags"] ) {

        NSLog(@"%d",setting.cell.pickerView.gestureRecognizers.count);
    } else {
        setting.cell.settingLabel.text = rowItem;
    }
    setting.currentSetting = rowItem;
    
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
    
    [setting.cell addSubview:setting.cell.pickerView];
    
    setting.cell.pickerView.alpha = 0.0f;
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
}


@end
