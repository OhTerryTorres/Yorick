//
//  MonologueDetailTableViewController.m
//  Yorick
//
//  Created by TerryTorres on 7/7/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "MonologueViewController.h"


#define numberOfSections 4
#define monologueNotes 0
#define monologueText 1
#define monologueTags 2
#define monologueRelated 3

@interface MonologueViewController ()

@end

@implementation MonologueViewController


#pragma mark: View Changing Methods

-(void)viewDidLoad {
    [super viewDidLoad];
    [self addSwipeGestureRecognizers];
    self.relatedMonologues = [[NSMutableArray alloc] init];
    [self setUpHeaderTitle];
    [self setUpFavoriteButton];
}
-(void)setUpHeaderTitle {
    self.navigationItem.title = @"Monologues";
}
-(void)setUpFavoriteButton {
    UIImage* image = [self imageBasedOnCurrentMonologueFavoriteStatus];
    self.favoriteButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(addMonologueToFavorites)];
    self.navigationItem.rightBarButtonItem = self.favoriteButton;
}

// Refreshes data, if needed
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super viewDidAppear:animated];
    [self loadData:YES];
}


#pragma mark: Display Setup

- (void)loadData:(BOOL)async {
    if (async) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateData1];
            [self updateData2];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });
        });
    } else {
        [self updateData1];
        [self updateData2];
        [self updateUI];
    }
}
-(void)updateData1 {
    self.textArray = [self splitTextIntoArray:self.currentMonologue.text];
    self.tagsArray = [self loadTagsIntoArray:self.currentMonologue.tags];

}
-(void)updateData2 {
    self.relatedMonologues = [self findMonologuesRelatedToMonologue:self.currentMonologue inArrayOfMonologues:self.detailsDataSource];
}
-(void)updateUI {
    [self.tableView reloadData];
    self.favoriteButton.image = [self imageBasedOnCurrentMonologueFavoriteStatus];
}

-(NSArray*)splitTextIntoArray:(NSString*)text {
    NSString *sep = @"\n";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    NSArray *textArray = [text componentsSeparatedByCharactersInSet:set];
    return textArray;
}

-(NSArray*)loadTagsIntoArray:(NSString*)tags {
    // Dealing with tags here
    NSString *sep = @" ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    tags = [tags stringByReplacingOccurrencesOfString:@"!" withString:@""];
    return [tags componentsSeparatedByCharactersInSet:set];
}

// Here, we'll go through the entire database, and make a new dictinoary ordered from the most "matches" to least
// In the end, just the top 3 will be displayed.
-(NSMutableArray*)findMonologuesRelatedToMonologue:(Monologue*)monologue inArrayOfMonologues:(NSArray*)sourceMonologues {
    NSMutableArray* relatedMonologues = [[NSMutableArray alloc] init];
    for (int i = 0; i < sourceMonologues.count; i++) {
        int matches = 0;
        Monologue *comparativeMonologue = sourceMonologues[i];
        NSArray *comparativeMonologueTags = [[NSArray alloc] initWithArray:[self loadTagsIntoArray:comparativeMonologue.tags]];
        
        
        if ( [monologue.tone isEqualToString:comparativeMonologue.tone] ) {
            matches++;
        }
        if ( [monologue.period isEqualToString:comparativeMonologue.period] ) {
            matches++;
        }
        if ( [monologue.age isEqualToString:comparativeMonologue.age] ) {
            matches++;
        }
        
        for (int t = 0; t < comparativeMonologueTags.count; t++) {
            if ( [self.tagsArray containsObject:comparativeMonologueTags[t]] ) {
                matches++;
            }
        }
        
        comparativeMonologue.matches = matches;
        
        // This makes sure that the current monologue isn't added to the list
        if ( comparativeMonologue.idNumber != monologue.idNumber && ![relatedMonologues containsObject:comparativeMonologue] ) {
            [relatedMonologues addObject:comparativeMonologue];
        }
        
    }
    NSMutableArray *sortedRelatedMonologues = [[relatedMonologues sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
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
    
    // In case there are no related monologues
    if ( sortedRelatedMonologues.count == 0 ) {
        Monologue *nullMonologue = [[Monologue alloc] init];
        nullMonologue.title = @"No related monologues";
        nullMonologue.authorFirst = @"For this";
        nullMonologue.authorLast = @"monologue, anyway";
        nullMonologue.text = @"Go figure";
        [sortedRelatedMonologues addObject:nullMonologue];
    }
    
    return sortedRelatedMonologues;
}

#pragma mark: TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Defined at the top
    return numberOfSections;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [YorickStyle color3];
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
    if ( section == monologueText ) {
        return self.textArray.count;
    } else if ( section == monologueTags ) {
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

// Each section makes use of a protoype cell, which is used to help deal with varying height depending on the lenght of the monologue an the size of the display text.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *currentTag = @"";
    Monologue *relatedMonologue;
    
    switch ( indexPath.section ) {
        case monologueText:
            cell = [tableView dequeueReusableCellWithIdentifier:@"text" forIndexPath:indexPath];
            [self configureCell:cell forRowAtIndexPath:indexPath];
            break;
        case monologueNotes:
            self.notesCell = [tableView dequeueReusableCellWithIdentifier:@"notes"];
            self.notesCell.titleLabel.text = self.currentMonologue.title;
            self.notesCell.characterLabel.text = self.currentMonologue.character;
            self.notesCell.notesLabel.text = self.currentMonologue.notes;
            cell = self.notesCell;
            break;
        case monologueTags:
            self.tagCell = [tableView dequeueReusableCellWithIdentifier:@"tags"];
            currentTag = self.tagsArray[indexPath.row];
            self.tagCell.textLabel.text = currentTag;
            [self.tagCell.textLabel setTextColor:[YorickStyle color2]];
            self.tagCell.textLabel.userInteractionEnabled = YES;
            cell = self.tagCell;
            break;
        case monologueRelated:
            relatedMonologue = self.relatedMonologues[indexPath.row];
            cell = [self getCellForRelatedMonologue:relatedMonologue atIndexPath:indexPath];
            if ([relatedMonologue.title isEqualToString:@"No related monologues"]) {
                cell.userInteractionEnabled = false;
            }
            break;
        default:
            break;
    }

    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TextTableViewCell *textCell = (TextTableViewCell *)cell;
    textCell.monologueTextLabel.font = [YorickStyle defaultFontOfSize:self.manager.textSize];
    textCell.monologueTextLabel.numberOfLines = 0;
    textCell.monologueTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textCell.monologueTextLabel.text = self.textArray[indexPath.row];
    textCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

// Necessary for updating textcell
-(TextTableViewCell*)textCell {
    if (!_textCell) {
        _textCell = [self.tableView dequeueReusableCellWithIdentifier:@"text"];
    }
    return _textCell;
}

-(MonologueTableViewCell*)getCellForRelatedMonologue:(Monologue*)monologue atIndexPath:(NSIndexPath*)indexPath {
    MonologueTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"related"forIndexPath:indexPath];
    cell.titleLabel.text = monologue.title;
    cell.characterLabel.text = monologue.character;
    [cell setExcerptLabelWithString: monologue.text];
    
    return cell;
}


// Touch related monologue cell, and go to the appropriate monologue
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == monologueRelated ) {
        [self loadRelatedMonologueForIndexPath:indexPath];
    }
}
-(void)loadRelatedMonologueForIndexPath:(NSIndexPath*)indexPath {
    self.detailIndex = [self getNewDetailIndexForMonologue:self.relatedMonologues[indexPath.row]];
    [self swipeToNewMonologue:self.relatedMonologues[indexPath.row] willSwipeToRight:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    switch ( indexPath.section ) {
        case monologueText:
            size = [self sizeForTextCellAtIndexPath:indexPath];
            break;
        case monologueNotes:
            size = [self sizeForNotesCellAtIndexPath:indexPath];
            break;
        case monologueTags:
            size = [self sizeForTagsCellAtIndexPath:indexPath];
            break;
        default:
            size.height = [self.tableView rowHeight];
            break;
    }
    
    return size.height+1;
}
-(CGSize)sizeForTextCellAtIndexPath:(NSIndexPath*)indexPath {
    [self configureCell:self.textCell forRowAtIndexPath:indexPath];
    self.textCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.textCell.bounds));
    [self.textCell layoutIfNeeded];
    return [self.textCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}
-(CGSize)sizeForNotesCellAtIndexPath:(NSIndexPath*)indexPath {
    self.notesCell.notesLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.notesCell.textLabel.frame);
    return [self.notesCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}
-(CGSize)sizeForTagsCellAtIndexPath:(NSIndexPath*)indexPath {
    self.tagCell.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tagCell.textLabel.frame);
    return [self.tagCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


#pragma mark - Navigation

// The only segue from this screen is back to the Browse screen.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MonologuesListViewController *mlvc = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSString *c = self.tagsArray[path.row];
    mlvc.searchController.active = YES;
    mlvc.searchController.searchBar.text = [NSString stringWithFormat:@"!%@",c];
    // Exclamation point (!) will search for monologue tags in particular
    // as opposed to just a blanket search for all text anywhere.
}


#pragma mark: User Interaction

-(UIImage*)imageBasedOnCurrentMonologueFavoriteStatus {
    UIImage * image;
    if ( [self.manager monologueWithIDNumberIsInFavorites:self.currentMonologue.idNumber] ) {
        image = [UIImage imageNamed:@"favorites-selected"];
    } else {
        image = [UIImage imageNamed:@"favorites-unselected"];
    }
    return image;
}
-(void)addMonologueToFavorites {
    PopUpView* popUp;
    if ( [self.manager monologueWithIDNumberIsInFavorites:self.currentMonologue.idNumber] ) {
        self.favoriteButton.image = [UIImage imageNamed:@"favorites-unselected"];
        [self.manager.favoriteMonologues removeObject:[self.manager getFavoriteMonologueForIDNumber:self.currentMonologue.idNumber]];
        popUp = [[PopUpView alloc] initWithTitle:@"Removed from Favorites"];
        
    } else {
        self.favoriteButton.image = [UIImage imageNamed:@"favorites-selected"];
        Monologue *favoriteMonologue = [self.currentMonologue copy];
        [self.manager.favoriteMonologues addObject:favoriteMonologue];
        popUp = [[PopUpView alloc] initWithTitle:@"Added to Favorites"];
    }
    [self.tabBarController.view addSubview:popUp];
}
-(void)addSwipeGestureRecognizers {
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedLeft:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGesture];
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetectedRight:) ];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesture];
    
}


// This handles swipe gestures
- (void)swipeDetectedRight:(UISwipeGestureRecognizer *)sender
{
    //Access previous cell in TableView
    if (self.detailIndex != 0) { // This way it will not go negative
        self.detailIndex--;
        [self swipeToNewMonologue:self.detailsDataSource[self.detailIndex] willSwipeToRight:YES];
        // YES will scroll to the right
    }
}

- (void)swipeDetectedLeft:(UISwipeGestureRecognizer *)sender
{
    //Access next cell in TableView
    // The count is always greater than the index, which is why the count is being subtracted by 1.
    if ( self.detailIndex != (self.detailsDataSource.count -1) ) { // make sure that it does not go over the number of objects in the array.
        self.detailIndex++;  // you'll need to check bounds
        [self swipeToNewMonologue: self.detailsDataSource[self.detailIndex] willSwipeToRight:NO];
        // NO will scroll to the left
    }
}

-(void)swipeToNewMonologue:(Monologue*)monologue willSwipeToRight:(BOOL)swipeRight {
    // Disable interaction to avoid glitching
    self.tabBarController.view.userInteractionEnabled = NO;
    CGRect homeFrame = self.view.frame;
    
    // Bring it off screen.
    [UIView animateWithDuration:0.20
                     animations: ^{
                         // Animate the views on and off the screen.
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         self.view.frame = CGRectMake((swipeRight ? self.view.frame.size.width : -self.view.frame.size.width), self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:0.01
                                              animations: ^{
                                                  // Animate the views on and off the screen.
                                                  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                                  
                                              } completion:^(BOOL finished) {
                                                  self.currentMonologue = monologue;
                                                  [self loadData:NO];
                                                  
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
                                                                       }}];}];}}];
    
                             
}


// Used to define the current monologue's position in the array of monologue being displayed on the previous screen.
-(int)getNewDetailIndexForMonologue:(Monologue*)monologue {
    int i = 0;
    
    while ( i < self.detailsDataSource.count ) {
        Monologue *comparativeMonologue = self.detailsDataSource[i];

        if ( comparativeMonologue.idNumber == monologue.idNumber ) {
            return i;
        }
        
        i++;
    }
    return i;
}


@end
