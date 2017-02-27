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
        if ( comparativeMonologue.idNumber != self.currentMonologue.idNumber ) {
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
        nullMonologue.cell.userInteractionEnabled = FALSE;
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    Setting *sizeSetting = self.manager.settings[3];
    NSString *textSizeString = sizeSetting.currentSetting;
    NSString *currentTag = @"";
    Monologue *relatedMonologue = [[Monologue alloc] init];
    
    switch ( indexPath.section ) {
        case monologueText:
            self.textCell = [tableView dequeueReusableCellWithIdentifier:@"text"];
            if ( [textSizeString isEqualToString:@"Normal"] ) {
                self.textCell.monologueTextLabel.font = [YorickStyle defaultFontOfSize:[YorickStyle defaultFontSize]];
            }
            if ( [textSizeString isEqualToString:@"Large"] ) {
                self.textCell.monologueTextLabel.font = [YorickStyle defaultFontOfSize:[YorickStyle largeFontSize]];
            }
            if ( [textSizeString isEqualToString:@"Very Large"] ) {
                self.textCell.monologueTextLabel.font = [YorickStyle defaultFontOfSize:[YorickStyle veryLargeFontSize]];
            }
            if ( [textSizeString isEqualToString:@"Largest"] ) {
                self.textCell.monologueTextLabel.font = [YorickStyle defaultFontOfSize:[YorickStyle largestFontSize]];
            }
            self.textCell.monologueTextLabel.numberOfLines = 0;
            self.textCell.monologueTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.textCell.monologueTextLabel.text = self.currentMonologue.text;
            cell = self.textCell;
            [self addTapGestureRecognizerToCell:cell];
            break;
        case monologueNotes:
            self.notesCell = [tableView dequeueReusableCellWithIdentifier:@"notes"];
            self.notesCell.titleLabel.text = self.currentMonologue.title;
            self.notesCell.characterLabel.text = self.currentMonologue.character;
            self.notesCell.notesLabel.text = self.currentMonologue.notes;
            cell = self.notesCell;
            [self addTapGestureRecognizerToCell:cell];
            break;
        case monologueTags:
            self.tagCell = [tableView dequeueReusableCellWithIdentifier:@"tags"];
            currentTag = [self.tagsArray objectAtIndex:indexPath.row];
            self.tagCell.textLabel.text = currentTag;
            [self.tagCell.textLabel setTextColor:[YorickStyle color2]];
            self.tagCell.textLabel.userInteractionEnabled = YES;
            cell = self.tagCell;
            break;
        case monologueRelated:
            relatedMonologue = [self getRelatedMonologueForIndexPath:indexPath];
            if ([relatedMonologue.title isEqualToString:@"No related monologues"]) {
                relatedMonologue.cell.userInteractionEnabled = false;
            }
            cell = relatedMonologue.cell;
            break;
        default:
            break;
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

-(void)addTapGestureRecognizerToCell:(UITableViewCell*)cell {
    // This adds tap gesture recognizer as well
    cell.gestureRecognizers = nil;
    cell.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [cell addGestureRecognizer:tapGestureRecognizer];
}

// Touch related monologue cell, and go to the appropriate monologue
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == monologueRelated ) {
        [self monologueTransitionForIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch ( indexPath.section ) {
        case monologueText:
            [self.textCell.contentView setNeedsLayout];
            [self.textCell.contentView layoutIfNeeded];
            self.textCell.monologueTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.textCell.monologueTextLabel.frame);
            size = [self.textCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        case monologueNotes:
            [self.notesCell.contentView setNeedsLayout];
            [self.notesCell.contentView layoutIfNeeded];
            self.notesCell.notesLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.notesCell.notesLabel.frame);
            size = [self.notesCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        case monologueTags:
            [self.tagCell.contentView setNeedsLayout];
            [self.tagCell.contentView layoutIfNeeded];
            self.tagCell.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
            size = [self.tagCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
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
    if ( [self.manager monologueWithIDNumberIsInFavorites:self.currentMonologue.idNumber] ) {
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
    if ( [self.manager monologueWithIDNumberIsInFavorites:self.currentMonologue.idNumber] ) {
        // gray
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-undug"];
        self.favoriteButtonOutlet.tintColor = [YorickStyle color1];
        // This makes it so that a monologue can be removed from Digs in both the Digs and Boneyard screen.
        [self.manager.favoriteMonologues removeObject:[self.manager getFavoritesMonologueForIDNumber:self.currentMonologue.idNumber]];
        
        PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Removed from Digs"];
        [self.tabBarController.view addSubview:popUp];
    } else {
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-dug"];
        self.favoriteButtonOutlet.tintColor = [YorickStyle color1];
        Monologue *favoriteMonologue = [self.currentMonologue copy];
        [self.manager.favoriteMonologues addObject:favoriteMonologue];
        
        PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Added to Digs"];
        [self.tabBarController.view addSubview:popUp];
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
    backView = nil;
                    
                             
}

-(void)monologueTransitionForIndexPath:(NSIndexPath*)indexPath {
    CGRect homeFrame = self.view.frame;
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
                                                                       }}];}];}}];
}


-(void)getNewDetailIndex {
    NSLog(@"self.detailDataSource.count is %lu",(unsigned long)self.detailsDataSource.count);
    int i = 0;
    
    while ( i < self.detailsDataSource.count ) {
        Monologue *monologue = self.detailsDataSource[i];

        if ( monologue.idNumber == self.currentMonologue.idNumber ) {
            self.detailIndex = i;
            NSLog(@"self.detailIndex is %lu",self.detailIndex);
        }
        
        i++;
    }
}



@end
