//
//  MonologueDetailTableViewController.m
//  Yorick
//
//  Created by TerryTorres on 7/7/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "MonologueViewController.h"

// These definitions will make creating the table view much simpler
// numberOfSections corresponds to each section in the table
// (that is, each individual component of the selected monologue)
// This needs to be updated each time a new section is added

#define numberOfSections 4

// This defines the order of individual sections
#define monologueNotes 0
#define monologueText 1
#define monologueTags 2
#define monologueRelated 3

@interface MonologueViewController ()

@end

@implementation MonologueViewController


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

-(void)viewDidLoad {
    [super viewDidLoad];
    self.barsHidden = 0;
    [self addSwipeGestureRecognizers];
}

// Refreshes data, if needed
-(void)viewWillAppear:(BOOL)animated{
    [self getManagerFromAppDelegate];
    [super viewWillAppear:animated];
    [super viewDidAppear:animated];
    
    [self loadData];
    
    [self maintainView];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self passManagerToAppDelegate];
    self.cgFloatY = self.tableView.contentOffset.y;
}


#pragma mark: Display Setup

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.tagsArray = [self loadTagsIntoArray:self.currentMonologue.tags];
        [self compileRelatedMonologuesfromArrayOfMonologues: self.detailsDataSource];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self loadHeaderTitle];
            [self setFavoriteStatus];
        });
    });
}

-(NSArray*)loadTagsIntoArray:(NSString*)tags {
    // Dealing with tags here
    NSString *sep = @" ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    tags = [tags stringByReplacingOccurrencesOfString:@"!" withString:@""];
    return [tags componentsSeparatedByCharactersInSet:set];
}

// Here, we'll go through the entire database, and make a new dictinoary ordered from the most "matches" to least"
// In the end, just the top 3 will be displayed.
-(void)compileRelatedMonologuesfromArrayOfMonologues:(NSArray*)sourceMonologues {
    self.relatedMonologues = [[NSMutableArray alloc] init];
    // relatedMonologuesDictionary will store the number of matches each monologue has to the current monologue
    // under the key: "%@ %d", comparativeMonologue.title, numberOfMatches
    
    int i = 0;
    while ( i < sourceMonologues.count ) {
        int matches = 0;
        Monologue *comparativeMonologue = [sourceMonologues objectAtIndex:i];;
        NSArray *comparativeMonologueTags = [[NSArray alloc] initWithArray:[self loadTagsIntoArray:comparativeMonologue.tags]];
        
        
        if ( [self.currentMonologue.tone isEqualToString:comparativeMonologue.tone] ) {
            matches++;
        }
        if ( [self.currentMonologue.period isEqualToString:comparativeMonologue.period] ) {
            matches++;
        }
        if ( [self.currentMonologue.age isEqualToString:comparativeMonologue.age] ) {
            matches++;
        }
        
        int t = 0;
        while ( t < comparativeMonologueTags.count ) {
            if ( [self.tagsArray containsObject:comparativeMonologueTags[t]] ) {
                matches++;
            }
            t++;
        }
        
        comparativeMonologue.matches = matches;
        
        // This makes sure that the current monologue isn't added to the list
        if ( ![comparativeMonologue.title isEqualToString:self.currentMonologue.title] ) {
            [self.relatedMonologues addObject:comparativeMonologue];
        }
        
        i++;
    }
    NSMutableArray *sortedRelatedMonologues;
    sortedRelatedMonologues = [[self.relatedMonologues sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        int first = [(Monologue*)a matches];
        int second = [(Monologue*)b matches];
        if (first < second)
            return NSOrderedAscending;
        else if (first > second)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }] mutableCopy];
    
    
    
    sortedRelatedMonologues = [[[sortedRelatedMonologues reverseObjectEnumerator] allObjects] mutableCopy];
    self.relatedMonologues = [sortedRelatedMonologues mutableCopy];
    
    // In case there are no related monologues
    if ( self.relatedMonologues.count == 0 ) {
        Monologue *nullMonologue = [[Monologue alloc] init];
        nullMonologue.title = @"No related monologues";
        nullMonologue.authorFirst = @"For this";
        nullMonologue.authorLast = @"monologue, anyway";
        nullMonologue.text =@"Go figure";
        [self.relatedMonologues addObject:nullMonologue];
    }
}

-(void)loadHeaderTitle {
    // This displays the amount of monologues currently in the list
    // +1 to adjust for the zero index
    NSString *headerTitle = [NSString stringWithFormat:@"Boneyard (%lu/%lu)",self.detailIndex+1,(unsigned long)self.detailsDataSource.count];
    [self.navigationItem setTitle:headerTitle];
}

-(void)maintainView {
    // This remembers the y value of the monologue screen even between tabs, so it doesn't flip out or reload improperly
    [UIView animateWithDuration:0.0 delay:0.0 options:0 animations:^{
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        self.tableView.contentOffset = CGPointMake(0, self.cgFloatY);
    }];
}

- (BOOL)prefersStatusBarHidden {
    if ( self.barsHidden == 1 ) {
        return YES;
    } else {
        return NO;
    }
    
}


#pragma mark: TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // Defined at the top
    return numberOfSections;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{

    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    header.contentView.backgroundColor = [YorickStyle color1];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case monologueText:
            return @"Text";
            break;
        case monologueNotes:
            return @"Notes";
            break;
        case monologueTags:
            return @"Tags";
            break;
        case monologueRelated:
            return @"Related Monologues";
            break;
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ( section == monologueTags ) {
        return self.tagsArray.count;
    } else if ( section == monologueRelated ) {
        if ( self.relatedMonologues.count > 3) {
            return 3;
        } else {
            return self.relatedMonologues.count;
        }
        
    } else {
        return 1;
    }
}

// Several steps need to be taken so that each piece of data from the current monologue is displayed properly.
// Each section requires its own cell indentifier to start the process
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier;
    
    switch ( indexPath.section ) {
        case monologueText:
            cellIdentifier = @"UYLTextCellText";
            break;
        case monologueNotes:
            cellIdentifier = @"UYLTextCellNotes";
            break;
        case monologueTags:
            cellIdentifier = @"UYLTextCellTags";
            break;
        case monologueRelated:
            cellIdentifier = @"related";
            break;
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    if ( indexPath.section == monologueTags) {
        NSString *currentTag = [self.tagsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = currentTag;
        [cell.textLabel setTextColor:[YorickStyle color2]];
        cell.userInteractionEnabled = YES;
    } else if ( indexPath.section == monologueRelated ) {
        Monologue *currentMonologue = [self getRelatedMonologueForIndexPath:indexPath];
        
        return currentMonologue.cell;
    } else {
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }

    return cell;
}

-(Monologue*)getRelatedMonologueForIndexPath:(NSIndexPath*)indexPath {
    Monologue *currentMonologue = [self.relatedMonologues objectAtIndex:indexPath.row];
    
    currentMonologue.cell = [self.tableView dequeueReusableCellWithIdentifier:@"related"forIndexPath:indexPath];
    currentMonologue.cell.titleLabel.text = currentMonologue.title;
    currentMonologue.cell.characterLabel.text = currentMonologue.character;
    [currentMonologue.cell setExcerptLabelWithString: currentMonologue.text];
    
    return currentMonologue;
}

// This is used to populate each label in the table view, regardless of what cell its associated with.
// This also makes sure the cell is of a custom table cell class (UYLTextCell).
// This actually may not be the most efficient way of distributing the data across the appropriate cells,
// (each cell seems to carry this information, whether or not each cell needs it) but it works.
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [cell isKindOfClass:[UYLTextCell class]] ) {
        UYLTextCell *textCell = (UYLTextCell *)cell;
        textCell.cellTextLabel.text = self.currentMonologue.text;
        Setting *sizeSetting = self.manager.settings[3];
        NSString *textSizeString = sizeSetting.currentSetting;
        int textSize = 17;
        if ( [textSizeString isEqualToString:@"Normal"] ) {
            textSize = 17;
        }
        if ( [textSizeString isEqualToString:@"Large"] ) {
            textSize = 24;
        }
        if ( [textSizeString isEqualToString:@"Very Large"] ) {
            textSize = 31;
        }
        if ( [textSizeString isEqualToString:@"Largest"] ) {
            textSize = 38;
        }
        textCell.cellTextLabel.font = [UIFont systemFontOfSize:textSize];
        // .font is defined here in cases of resizing, stylistic choices, etc
        textCell.cellNotesLabel.text = self.currentMonologue.notes;
        textCell.cellTitleLabel.text = self.currentMonologue.title;
        textCell.cellCharacterLabel.text = self.currentMonologue.character;

        textCell.cellGenderLabel.text = self.currentMonologue.gender;
        textCell.cellPeriodLabel.text = self.currentMonologue.period;
        textCell.cellAgeLabel.text = self.currentMonologue.age;
        textCell.cellLengthLabel.text = self.currentMonologue.length;
        
        // This adds tap gesture recognizer as well
        textCell.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [textCell addGestureRecognizer:tapGestureRecognizer];
    }
}

// Touch related monologue cell, and go to the appropriate monologue
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == monologueRelated ) {
        [self monologueTransitionForIndexPath:indexPath];
    }
}

// Use this to adjust the height of cells in each individual section
//
// This is the method that utitilizes the proper prototype cell in the appropriate section.
// Each section requires:
// 1) a defined indexPath.section (monologueText)
// 2) a cellIdentifier (UYLTextCellText)
// 3) a prototype UYLTextCell (self.prototypeCellText)
// 4) a label identified in UYLTextCell.h (cellTextLabel)
// in order to display properly.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch ( indexPath.section ) {
        case monologueText:
            [self configureCell:self.prototypeCellText forRowAtIndexPath:indexPath];
            [self.prototypeCellText layoutIfNeeded];
            size = [self.prototypeCellText.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            NSLog(@"monologueText size.height is %f",size.height);
            NSLog(@"monologueText size.width is %f",size.width);
            break;
        case monologueNotes:
            [self configureCell:self.prototypeCellNotes forRowAtIndexPath:indexPath];
            [self.prototypeCellNotes layoutIfNeeded];
            size = [self.prototypeCellNotes.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        case monologueTags:
            [self configureCell:self.prototypeCellTags forRowAtIndexPath:indexPath];
            [self.prototypeCellTags layoutIfNeeded];
            size = [self.prototypeCellTags.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        default:
            size.height = [self.tableView rowHeight];
            break;
    }
    
    return size.height+1;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//
// Create a prototype cell for each new data section
//
// ******** Is this nonsense??
// This bit is more complicated. A new prototype cell is created for each individual section.
// The existence of the prototype cell is what allows each cell's height change depending on
// its content. As a result, there needs to be a different prototype for each section, so
// they can each be the appropriate size.

- (UYLTextCell *)prototypeCellText
{
    if (!_prototypeCellText)
    {
        _prototypeCellText = [self.tableView dequeueReusableCellWithIdentifier:@"UYLTextCellText"];
    }
    return _prototypeCellText;
}

- (UYLTextCell *)prototypeCellNotes
{
    if (!_prototypeCellNotes)
    {
        _prototypeCellNotes = [self.tableView dequeueReusableCellWithIdentifier:@"UYLTextCellNotes"];
    }
    return _prototypeCellNotes;
}

- (UYLTextCell *)prototypeCellTags
{
    if (!_prototypeCellTags)
    {
        _prototypeCellTags = [self.tableView dequeueReusableCellWithIdentifier:@"UYLTextCellTags"];
    }
    return _prototypeCellTags;
}



#pragma mark - Navigation

// The only segue from this screen is back to the Browse screen.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MonologuesListViewController *mlvc = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSString *c = self.tagsArray[path.row];
    mlvc.searchController.active = YES;
    mlvc.searchController.searchBar.text = [NSString stringWithFormat:@"!%@",c];
    // Exclamation point (!) will search for monologue tags in particular
    // as opposed to just a blanket search for all text anywhere.
}


#pragma mark: User Interaction

-(void)setFavoriteStatus {
    // Decides color of Favorite button
    if ( [self.manager.favoriteMonologues containsObject:self.currentMonologue] || [self.manager.favoriteMonologues containsObject:[self.manager getMonologueForTitle:self.currentMonologue.title]] ) {
        // Add image to button for normal state
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-dug"];
        self.favoriteButtonOutlet.tintColor = [YorickStyle color1];
    } else {
        // gray
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-undug"];
        self.favoriteButtonOutlet.tintColor = [YorickStyle color1];
    }
}

- (IBAction)favoriteButtonAction:(id)sender {

    [self addMonologueToFavorites];
    
}

-(void)addMonologueToFavorites {
    if ( [self.manager.favoriteMonologues containsObject:self.currentMonologue] ) {
        // gray
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-undug"];
        self.favoriteButtonOutlet.tintColor = [YorickStyle color1];
        [self.manager.favoriteMonologues removeObject:self.currentMonologue];
        if ( [self.manager.editedMonologues containsObject:self.currentMonologue] ) {
            [self.manager.editedMonologues removeObject:self.currentMonologue];
        }
        
        PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Removed from Digs"];
        [self.navigationController.view addSubview:popUp];
    } else {
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-dug"];
        self.favoriteButtonOutlet.tintColor = [YorickStyle color1];
        [self.manager.favoriteMonologues addObject:self.currentMonologue];
        
        PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Added to Digs"];
        [self.navigationController.view addSubview:popUp];
    }
}


-(void)addSwipeGestureRecognizers {
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedLeft:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGesture];
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedRight:) ];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesture];
    
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    if ( self.barsHidden == 0 || self.barsHidden == 2 ) {
        self.barsHidden = 1;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.navigationController.navigationBarHidden = YES;
                             TabBarController* tbc = (TabBarController*)self.tabBarController;
                             [tbc hideTabBar];
                         }];
    } else {
        self.barsHidden = 2;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.navigationController.navigationBarHidden = NO;
                             TabBarController* tbc = (TabBarController*)self.tabBarController;
                             [tbc showTabBar];
                         }];
    }
}


// This handles swipe gestures
- (void)swipeDetectedRight:(UISwipeGestureRecognizer *)sender
{
    //Access previous cell in TableView
    if (self.detailIndex != 0) { // This way it will not go negative
        self.detailIndex--;
        [self swipeAnimation:YES];
        // YES == scroll to the right
    }
}

- (void)swipeDetectedLeft:(UISwipeGestureRecognizer *)sender
{
    //Access next cell in TableView
    // The count is always greater than the index, which is why the count is being subtracted by 1.
    if ( self.detailIndex != (self.detailsDataSource.count -1) ) { // make sure that it does not go over the number of objects in the array.
        self.detailIndex++;  // you'll need to check bounds
        [self swipeAnimation:NO];
        // NO == scroll to the left
    }
}

-(void)swipeAnimation:(BOOL)swipeRight {
    // Disable interaction to avoid glitching
    self.tabBarController.view.userInteractionEnabled = NO;
    CGRect homeFrame = self.view.frame;
    UIView* backView;
    backView.frame = self.view.frame;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view.superview addSubview:backView];
    [self.view.superview sendSubviewToBack:backView];
    
    // Bring it off screen.
    [UIView animateWithDuration:0.20
                     animations: ^{
                         // Animate the views on and off the screen.
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         //fromView.frame = CGRectMake(viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                         self.view.frame = CGRectMake((swipeRight ? self.view.frame.size.width : -self.view.frame.size.width), self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:0.01
                                              animations: ^{
                                                  // Animate the views on and off the screen.
                                                  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                                  
                                              } completion:^(BOOL finished) {
                                                  self.currentMonologue = [self.detailsDataSource objectAtIndex:self.detailIndex];
                                                  [self loadData];
                                                  
                                                  self.view.frame = CGRectMake((swipeRight ? -self.view.frame.size.width : self.view.frame.size.width), self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                                  [UIView animateWithDuration:0.20
                                                                   animations: ^{
                                                                       // Animate the views on and off the screen.
                                                                       [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                                                       self.view.frame = homeFrame;
                                                                       
                                                                   } completion:^(BOOL finished) {
                                                                       if (finished) {
                                                                           // Restore interaction.
                                                                           self.tabBarController.view.userInteractionEnabled = YES;
                                                                           //[self loadData];
                                                                       }}];}];}}];
                    
                             
}

-(void)monologueTransitionForIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.20
                     animations: ^{
                         // Animate the views on and off the screen.
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         cell.frame = CGRectMake(-cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                         cell.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         // Disable interaction to avoid glitching
                         self.tabBarController.view.userInteractionEnabled = NO;
                         CGRect homeFrame = self.view.frame;
                         UIView* backView;
                         backView.frame = self.view.frame;
                         backView.backgroundColor = [UIColor whiteColor];
                         [self.view.superview addSubview:backView];
                         [self.view.superview sendSubviewToBack:backView];
                         
                         // Bring it off screen.
                         [UIView animateWithDuration:0.20
                                          animations: ^{
                                              // Animate the views on and off the screen.
                                              [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                              //fromView.frame = CGRectMake(viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                                              self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                          }
                                          completion:^(BOOL finished) {
                                              if (finished) {
                                                  [UIView animateWithDuration:0.01
                                                                   animations: ^{
                                                                       // Scroll to top
                                                                       // For some reason, this has to be an animation.
                                                                       [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                                                       
                                                                   } completion:^(BOOL finished) {
                                                                       self.currentMonologue = [self.relatedMonologues objectAtIndex:indexPath.row];
                                                                       [self getNewDetailIndex];
                                                                       
                                                                       [self loadData];
                                                                       
                                                                       self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                                                       [UIView animateWithDuration:0.20
                                                                                        animations: ^{
                                                                                            // Animate the views on and off the screen.
                                                                                            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                                                                            self.view.frame = homeFrame;
                                                                                            
                                                                                        } completion:^(BOOL finished) {
                                                                                            if (finished) {
                                                                                                // Restore interaction.
                                                                                                self.tabBarController.view.userInteractionEnabled = YES;
                                                                                                //[self loadData];
                                                                                            }}];}];}}];
                     }];
}


-(void)getNewDetailIndex {
    NSLog(@"self.detailDataSource.count is %lu",(unsigned long)self.detailsDataSource.count);
    NSMutableArray *monologueTitles = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    while ( i < self.detailsDataSource.count ) {
        Monologue *monologue = self.detailsDataSource[i];
        NSString *title = monologue.title;
        [monologueTitles addObject:title];
        
        if ( [title isEqualToString:self.currentMonologue.title] ) {
            self.detailIndex = i;
            NSLog(@"self.detailIndex is %lu",self.detailIndex);
        }
        
        i++;
    }
}



@end
