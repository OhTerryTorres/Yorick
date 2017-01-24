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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    [self loadSettings];
    
    [self.tableView reloadData];
}

// Initialize arrays that will populate the pickerViews in the table.


// ***********
// If you were ever to change the number of available settings:
// Make sure that arrayOfTitles.count == arrayOfSettingsOptions.count
// They load into self.settingsArray, the most important value here.
// ***********

-(void) loadSettings {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.settingsArray = [[NSMutableArray alloc] init];
    
    // This makes the little lines dividing each table cell go all the way to the edge of the screen.
    // It also helps seperatorLineView blend in more effectively.
    //
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // This will keep an array of the title of each setting
    // Ideally, the order in which they are listed are the order in which they will appear
    
    
    // ****
    // AGE IS CURRENTLY DISABLED
    //
    
    //NSArray *arrayOfTitles = [[NSArray alloc] initWithObjects:@"gender", @"tone", @"age", @"length", @"sort", @"size", nil];
    NSArray *arrayOfTitles = [[NSArray alloc] initWithObjects:@"gender", @"tone", @"length", @"size", nil];
    
    // This will save the number and kinds of settings available to the user
    // This same list will be accessed later to filter displayed monologues
    if ([defaults objectForKey:@"settingsList"] == nil) {
        [defaults setObject:arrayOfTitles forKey:@"settingsList"];
    }
    
    
    
    // This will make a list of options for each setting
    NSArray *array0 = [[NSArray alloc] initWithObjects:@"Any", @"Female", @"Male", nil];
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"Any",@"Comedic", @"Tragic", @"Historic", nil];
    //NSArray *array2 = [[NSArray alloc] initWithObjects:@"Any", @"Classical", @"Contemporary", nil];
    //NSArray *array3 = [[NSArray alloc] initWithObjects:@"Any", @"Child", @"Adolescent", @"Young Adult", @"Adult", @"Middle Age", @"Elder", nil];
    NSArray *array4 = [[NSArray alloc] initWithObjects: @"Any", @"< 1 minute", @"< 2 minutes", @"> 2 minutes", nil];
    //NSArray *array5 = [[NSArray alloc] initWithObjects: @"Title", @"Author", nil];
    NSArray *array6 = [[NSArray alloc] initWithObjects: @"Normal", @"Large", @"Very Large", @"Largest", nil];
    
    
    // This will make an array of each list of settings options for the sake of iteration, just below
    //NSArray *arrayOfSettingsOptions = [[NSArray alloc] initWithObjects:array0, array1, array2, array3, array4, array5, array6, nil];
    NSArray *arrayOfSettingsOptions = [[NSArray alloc] initWithObjects:array0, array1, array4, array6, nil];
    
    // This allows the saved setting in user defaults to be access for each type of setting
    NSString *objectForKeyString;
    // This will take the necessary array out of arrayOfSettingsOptions for self.setting.settings
    // This is for the sake of iteration, below
    NSArray *arrayOfCurrentSetting;
    
    // Here, we'll attempt to load all of the values of each setting
    int i = 0;
    while ( i < arrayOfSettingsOptions.count )  {
        
        Setting *setting = [[Setting alloc] init];
        
        objectForKeyString = [NSString stringWithFormat:@"%@Setting",arrayOfTitles[i]];
        arrayOfCurrentSetting = [[NSArray alloc] initWithArray:[arrayOfSettingsOptions objectAtIndex:i]];
        
        if ([defaults objectForKey:objectForKeyString] != nil) {
            setting.currentSetting = [defaults objectForKey:objectForKeyString];
        } else {
            setting.currentSetting = arrayOfCurrentSetting[0];
        }
        setting.settings = [[NSArray alloc] initWithArray:arrayOfCurrentSetting];
        setting.title = [NSString stringWithFormat:@"%@",[arrayOfTitles objectAtIndex:i]];
        setting.defaultSetting = arrayOfCurrentSetting[0];
        
        setting.cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        setting.cell.titleLabel.text = [setting.title capitalizedString];
        setting.cell.settingLabel.text = setting.currentSetting;
        
        
        // **********
        
        // This block exists for the reformatting of particular visual settings.
        // If any settings are added or removed, this should be changed.
        
        // **********
        
        
        if ( [setting.title isEqualToString:@"size"] ) {
            setting.cell.titleLabel.text = @"Text Size";
            setting.cell.frame = CGRectOffset(setting.cell.frame, 10, 50);
            
            UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
            separatorLineView.backgroundColor = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
            [setting.cell.contentView addSubview:separatorLineView];
        }
        
        
        
        
        setting.cell.pickerView = [[UIPickerView alloc] init];
        setting.cell.pickerView.delegate = self;
        setting.cell.pickerView.dataSource = self;
        setting.cell.pickerView.tag = i;
        setting.maintainFrame = setting.cell.pickerView.frame;
        
        [self.settingsArray addObject:setting];
        
        setting = nil;
        
        i++;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.settingsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Configure the cell...
    // This figures out what is in row 0, 1, etc.
    // Different view for search results
    Setting *setting = [self.settingsArray objectAtIndex:indexPath.row];

    [setting.cell setNeedsUpdateConstraints];
    
    return setting.cell;
    
}




// Picker Stuff
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}


//
// If we use pickerView.tag, we can build each pickerView in each cell automatically.
//

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    
    // Get writting the setting object by referring to the tag of the current pickerView,
    // which we generated in the while loop back at loadsettings
    Setting *setting = nil;
    setting = [self.settingsArray objectAtIndex:pickerView.tag];
    
    NSMutableArray *array = [setting.settings mutableCopy];
    
    return array.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    
    Setting *setting = nil;
    setting = [self.settingsArray objectAtIndex:pickerView.tag];
    
    NSMutableArray *array = [setting.settings mutableCopy];
    
    return [array objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    ///
    //
    //
    // There could be some confustion as to when to use "picker" or "setting.picker" here
    
    Setting *setting = self.settingsArray[pickerView.tag];
    setting.currentSetting = [setting.settings objectAtIndex:[pickerView selectedRowInComponent:0]];
    setting.cell.settingLabel.text = [setting.settings objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *objectForKeyString = [NSString stringWithFormat:@"%@Setting",setting.title];
    [defaults setObject:setting.currentSetting forKey:objectForKeyString];
    
    setting.pickerRowDefault = [pickerView selectedRowInComponent:0];
    objectForKeyString = [NSString stringWithFormat:@"%@PickerRowDefault",setting.title];
    [defaults setInteger:setting.pickerRowDefault forKey:objectForKeyString];
    
}


// pickerView operational stuff (appearing, disappearing)


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Setting *setting = nil;
    setting = [self.settingsArray objectAtIndex:indexPath.row];
    CGFloat height = setting.pickerCellIsShowing ? setting.cell.pickerView.frame.size.height : self.tableView.rowHeight;
    
    /*
     // This may be important later
    if ( [setting.title isEqualToString:@"Length"] ) {
        height = setting.pickerCellIsShowing ? setting.cell.pickerView.frame.size.height : self.tableView.rowHeight + 10;
        UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        separatorLineView.backgroundColor = [UIColor redColor];
        [setting.cell.contentView addSubview:separatorLineView];
    }
    */
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Setting *setting = self.settingsArray[indexPath.row];
    if ( setting.pickerCellIsShowing ) {
        [self pickerCellHide:setting];
    } else {
        
        for ( int i = 0; i < self.settingsArray.count; i++) {
            setting = self.settingsArray[i];
            if ( self.settingsArray[i] == self.settingsArray[indexPath.row] ) {
                [self pickerCellShow:setting];
            } else {
                [self pickerCellHide:setting];
            }
        }
        
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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

    //CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y - self.tableView.rowHeight, self.view.frame.size.width, 216);
    //UIView *newView = [[UIView alloc] initWithFrame:newRect];
    //[newView addSubview:setting.cell.pickerView];
    
    //setting.cell.pickerView.frame = newRect;
    
    [setting.cell addSubview:setting.cell.pickerView];
    //[setting.cell insertSubview:setting.cell.pickerView atIndex:3];
    
    setting.cell.pickerView.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        //setting.cell.frame = rect;
        setting.cell.pickerView.alpha = 1.0f;
    }];
    
     
    NSString *integerForKeyString = [NSString stringWithFormat:@"%@PickerRowDefault",setting.title];
    setting.pickerRowDefault = [[NSUserDefaults standardUserDefaults] integerForKey:integerForKeyString];
    [setting.cell.pickerView selectRow:setting.pickerRowDefault inComponent:0 animated:YES];
    
}
- (void)pickerCellHide:(Setting*)setting {
    
    setting.cell.colored = NO;
    setting.cell.settingLabel.textColor = [UIColor grayColor];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *objectForKeyString;
    NSString *integerForKeyString;
    
    int i = 0;
    while (i < self.settingsArray.count) {
        Setting *setting = self.settingsArray[i];
        objectForKeyString = [NSString stringWithFormat:@"%@Setting",setting.title];
        integerForKeyString = [NSString stringWithFormat:@"%@PickerRowDefault",setting.title];
        [defaults setObject:setting.defaultSetting forKey:objectForKeyString];
        [setting.cell.pickerView selectRow:0 inComponent:0 animated:YES];
        [defaults setInteger:0 forKey:integerForKeyString];
        setting.currentSetting = setting.defaultSetting;
        setting.cell.settingLabel.text = setting.currentSetting;
        [self pickerCellHide:setting];
        
        i++;
    }
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
    [super viewWillAppear:animated];
    [self maintainView];
    
}

-(void)maintainView {
    // This remembers the y value of the monologue screen even between tabs, so it doesn't flip out or reload improperly
    [UIView animateWithDuration:0.25 animations:^{
        
        
    } completion:^(BOOL finished) {
        for ( int i = 0 ; i > self.settingsArray.count; i++) {
            Setting *setting;
            setting.cell.pickerView.frame = setting.maintainFrame;
        }
        
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for ( int i = 0 ; i > self.settingsArray.count; i++) {
        Setting *setting;
        setting.maintainFrame = setting.cell.pickerView.frame;
    }

}





@end
