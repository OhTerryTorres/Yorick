//
//  TagSearchController.m
//  Yorick
//
//  Created by TerryTorres on 3/3/17.
//  Copyright © 2017 Terry Torres. All rights reserved.
//

#import "TagSearchController.h"

@implementation TagSearchController

#pragma mark: View Lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    // Title
    [self updateTitle];
    
    // Index
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [YorickStyle color2];

}


#pragma mark: TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sectionTitles = [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *title = @"";
    if ( section < sectionTitles.count) {
        title = sectionTitles[section];
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    NSArray *sectionTitles = [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    if ( section < sectionTitles.count) {
        NSArray *monologueArray = [self.sections valueForKey:[sectionTitles objectAtIndex:section]];
        rows = (int)monologueArray.count;
    }
    return rows;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *currentTag = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    if ([self.manager.activeTags containsObject: currentTag]) {
        cell.textLabel.text = [NSString stringWithFormat:@"[  %@  ]", currentTag];
        cell.textLabel.textColor = [YorickStyle color2];
    } else {
        cell.textLabel.text = currentTag;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentTag = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self updateActiveTagsWithTag:currentTag];
    [self updateTitle];
    [tableView reloadData];
    TabBarController* tbc = (TabBarController*)self.tabBarController;
    [tbc updateBrowseBadge];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [YorickStyle color3];
}


#pragma mark: Class Data Methods

-(void)updateTitle {
    if (self.manager.activeTags.count == 0 ) {
        self.title = @"Tags";
    } else {
        self.title = [NSString stringWithFormat:@"Tags (%lu)",(unsigned long)self.manager.activeTags.count];
    }
    
}
-(void)updateActiveTagsWithTag:(NSString*)tag {
    if ( [self.manager.activeTags containsObject: tag] ) {
        [self.manager.activeTags removeObject: tag];
    } else {
        [self.manager.activeTags addObject: tag];
    }
}


#pragma mark: User Interaction

- (IBAction)clearTags:(id)sender {
    [self.manager.activeTags removeAllObjects];
    [self updateTitle];
    [self.tableView reloadData];
    PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Tag filters reset"];
    [self.tabBarController.view addSubview:popUp];
    TabBarController* tbc = (TabBarController*)self.tabBarController;
    [tbc updateBrowseBadge];
}


#pragma mark: Alphabetical Lookup

-(NSMutableDictionary*)getAlphabeticalSections:(NSMutableArray*)tags {
    BOOL found;
    NSMutableDictionary* sections = [[NSMutableDictionary alloc] init];
    
    int i = 0;
    for (NSString *tag in tags) {
        found = NO;
        NSString *firstLetter = [tag substringToIndex:1];
        
        for (NSString *str in [sections allKeys]) {
            if ([str isEqualToString:firstLetter]) {
                found = YES;
            }
        }
        
        // Makes sure first letter isn't a nil value
        if (!found && firstLetter) {
            [sections setValue:[[NSMutableArray alloc] init] forKey:firstLetter];
        }
        i++;
    }
    int o = 0;
    
    for (NSString *tag in tags) {
        [[sections objectForKey:[tag substringToIndex:1]] addObject:tag];
        o++;
    }
    
    return sections;
    
}



@end
