 //
//  OptionsViewController.m
//  Yorick
//
//  Created by TerryTorres on 3/5/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

-(void)getManagerFromAppDelegate {
    if (self.manager == nil) {
        AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
        self.manager = appDelegate.manager;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self getManagerFromAppDelegate];
    self.title = @"Options";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"settings" forIndexPath:indexPath];
            cell.textLabel.text = @"Type Filter";
            cell.detailTextLabel.text = @"Filter monologues by gender, tone, or length";
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"tags" forIndexPath:indexPath];
            cell.textLabel.text = @"Tag Filter";
            cell.detailTextLabel.text = @"Filter monologues that match a set of tags";
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"size" forIndexPath:indexPath];
            cell.textLabel.text = @"Text Size";
            cell.detailTextLabel.text = @"Change the display size of monologues";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.font = [YorickStyle defaultFontOfSize:[YorickStyle largeFontSize]];
    cell.detailTextLabel.font = [YorickStyle defaultFontOfSize:[YorickStyle smallFontSize]];
    cell.detailTextLabel.numberOfLines = 0;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - User Interaction

- (IBAction)clearFilters:(id)sender {
    [self.manager.activeTags removeAllObjects];
    int i = 0;
    while (i < self.manager.settings.count) {
        Setting *setting = self.manager.settings[i];
        setting.currentSetting = setting.options[0];
        setting.cell.settingLabel.text = setting.currentSetting;
        
        i++;
    }
    PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"All filters reset"];
    [self.tabBarController.view addSubview:popUp];
    TabBarController* tbc = (TabBarController*)self.tabBarController;
    [tbc updateBrowseBadge];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"tags"] ) {
        TagSearchController *tsc = segue.destinationViewController;
        tsc.manager = self.manager;
        tsc.sections = [tsc getAlphabeticalSections:self.manager.allTags];
    }
    if ( [segue.identifier isEqualToString:@"settings"] ) {
        SettingsViewController *svc = segue.destinationViewController;
        svc.manager = self.manager;
    }
    if ( [segue.identifier isEqualToString:@"size"] ) {
        SizeControlViewController *scvc = segue.destinationViewController;
        scvc.manager = self.manager;
    }
}


@end
