//
//  FavoriteMonologueViewController.m
//  Yorick
//
//  Created by TerryTorres on 7/16/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "FavoriteMonologueViewController.h"

@interface FavoriteMonologueViewController ()

// These definitions will make creating the table view much simpler
// numberOfSections corresponds to each section in the table
// (that is, each individual component of the selected monologue)
// This needs to be updated each time a new section is added

// The Favorite Monologues screen adds an extra section: Edit

#define numberOfSections 5
#define monologueNotes 0
#define monologueText 1
#define monologueTags 2
#define monologueEdit 3
#define monologueRelated 4


@end

@implementation FavoriteMonologueViewController {
    NSMutableArray *relatedMonologues;
}
//THIS allows for unwind segues, would should save time and space.
- (IBAction)cancelEdit:(UIStoryboardSegue *)segue {}
- (IBAction)saveEdit:(UIStoryboardSegue *)segue {}
- (IBAction)cancelTag:(UIStoryboardSegue *)segue {}
- (IBAction)saveTag:(UIStoryboardSegue *)segue {[self.tableView reloadData];}

// Refreshes data, if needed
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    [self maintainView];
    
    [self addSwipeGestureRecognizers];
    
}

- (void)loadData {
    NSLog(@"loadData");
    self.title = self.currentMonologue.title;
    [self setFavoriteStatus];
    self.tagsArray = [self loadTagsIntoArray:self.currentMonologue.tags];
    // Display edited version, if possible.
    [self retrieveEditedMonologue];
    [self compileRelatedMonologues];
    [self.tableView reloadData];
    
    // This displays the amount of monologues currently in the list
    // +1 to adjust for the zero index
    NSString *headerTitle = [NSString stringWithFormat:@"Digs (%lu/%lu)",self.detailIndex+1,(unsigned long)self.detailsDataSource.count];
    [self.navigationItem setTitle:headerTitle];
}

-(void)setFavoriteStatus {
    // Set Favorite Status
    NSMutableArray *favoriteMonologues;
    favoriteMonologues = [[NSMutableArray alloc] init];
    
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMonologues"] == nil ) {
        [[NSUserDefaults standardUserDefaults] setObject:favoriteMonologues forKey:@"favoriteMonologues"];
    }
    
    favoriteMonologues = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMonologues"];
    // used to be favoriteMonologues = [self loadCustomObjectWithKey:@"favoriteMonologues"]; but we changed it. Hold onto this data, though.
    
    // Decides color of Favorite button
    if ( [favoriteMonologues containsObject:self.currentMonologue.title] ) {
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-dug"];
        self.favoriteButtonOutlet.tintColor = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
    } else {
        // gray
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-undug"];
        self.favoriteButtonOutlet.tintColor = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
    }
}

-(NSArray*)loadTagsIntoArray:(NSString*)tags {
    // Dealing with tags here
    NSString *sep = @" ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    tags = [tags stringByReplacingOccurrencesOfString:@"!" withString:@""];
    return [tags componentsSeparatedByCharactersInSet:set];
}


// This also alters available edit options
-(void)retrieveEditedMonologue {
    NSLog(@"retrieveEdited");
    NSString *key = [NSString stringWithFormat:@"%@ edit",self.title];
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:key] ) {
        self.currentMonologue.text = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", @"Restore", nil];
    } else {
        self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", nil];
    }
    [self.tableView reloadData];
}


-(void)maintainView {
    // This remembers the y value of the monologue screen even between tabs, so it doesn't flip out or reload improperly
    [UIView animateWithDuration:0.0 delay:0.0 options:0 animations:^{
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        self.tableView.contentOffset = CGPointMake(0, self.cgFloatY);
    }];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.cgFloatY = self.tableView.contentOffset.y;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // Defined at the top
    return numberOfSections;
}

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
        case monologueEdit:
            return @"Options";
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
        if ( relatedMonologues.count > 3) {
            return 3;
        } else {
            return relatedMonologues.count;
        }
    } else if ( section == monologueEdit ) {
        return self.editArray.count;
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
        case monologueEdit:
            cellIdentifier = @"UYLTextCellEdit";
            break;
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // dealing with tags and edit section
    if ( indexPath.section == monologueTags ) {
        NSString *currentTag = [self.tagsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = currentTag;
        [cell.textLabel setTextColor:[UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:0.5]];
        cell.userInteractionEnabled = YES;
    } else if ( indexPath.section == monologueRelated ) {
        Monologue *currentMonologue = [relatedMonologues objectAtIndex:indexPath.row];
        
        MonologueTableViewCell *monologueCell = [tableView dequeueReusableCellWithIdentifier:@"related"];
        monologueCell.titleLabel.text = currentMonologue.title;
        monologueCell.characterLabel.text = currentMonologue.character;
        
        NSString *excerptString = currentMonologue.text;
        excerptString = [self excerptLabelFilter:excerptString];
        NSUInteger length = [excerptString length];
        if (length > 300) { length = 300; };
        // define the range you're interested in
        NSRange stringRange = {0, MIN([excerptString length], length)};
        // adjust the range to include dependent chars
        stringRange = [excerptString rangeOfComposedCharacterSequencesForRange:stringRange];
        // Now you can create the short string
        monologueCell.excerptLabel.text = [excerptString substringWithRange:stringRange];
        
        
        DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:0.5]];
        monologueCell.accessoryView = accessory;
        
        cell = monologueCell;
        
    } else if ( indexPath.section == monologueEdit ) {
        NSString *currentEdit = [self.editArray objectAtIndex:indexPath.row];
        cell.textLabel.text = currentEdit;
        [cell.textLabel setTextColor:[UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:0.5]];

        cell.userInteractionEnabled = YES;
    } else {
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
    
    return cell;
}

// This is used to populate each label in the table view, regardless of what cell its associated with.
// This also makes sure the cell is of a custom table celrl class (UYLTextCell).
// This actually may not be the most efficient way of distributing the data across the appropriate cells,
// (each cell seems to carry this information, whether or not each cell needs it) but it works.
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [cell isKindOfClass:[UYLTextCell class]] )
    {
        UYLTextCell *textCell = (UYLTextCell *)cell;
        textCell.cellTextLabel.text = self.currentMonologue.text;
        
        NSString *textSizeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"sizeSetting"];
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
            size = [self.prototypeCellText .contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
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
        case monologueEdit:
            size = [self.prototypeCellEdit.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            //Attemp to keep a buffer zone at the bottom.
            size.height += (size.height*.1);
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

// This bit is more complicated. A new prototype cell is created for each individual section.
// The existence of the prototype cell is what allows each cell's height change depending on
// its content. As a result, there needs to be a different prototype for each section, so
// they can each by the appropriate size.

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

- (UYLTextCell *)prototypeCellEdit
{
    if (!_prototypeCellEdit)
    {
        _prototypeCellEdit = [self.tableView dequeueReusableCellWithIdentifier:@"UYLTextCellEdit"];
    }
    return _prototypeCellEdit;
}

// For helping in searching for tags in the Browse screen
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];

    
    // Dealing with tags
    // This will perform a tag search in the Browse screen.
    if ( indexPath.section == monologueTags ) {
        NSString *c = self.tagsArray[path.row];
        NSString *object = [NSString stringWithFormat:@"!%@",c];
        NSLog(@"object in Favorites is %@",object);
        [self.tabBarController setSelectedIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:@"tagSearch"];
        
    }
    
    // Dealing with edit options
    if ( indexPath.section == monologueEdit ) {
        NSString *c = self.editArray[path.row];
        if ( [c isEqual:@"Add Tag"] ) {
            [self addTag];
        } else if ( [c isEqual:@"Edit"] ) {
            [self editMonologue];
        } else if ( [c isEqual:@"Restore"] ) {
            [self restoreMonologue];
        }
    }
    
    // Selecting a related monologue
    if ( indexPath.section == monologueRelated ) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
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
                                                                           self.currentMonologue = [relatedMonologues objectAtIndex:indexPath.row];
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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ( [segue.identifier isEqual: @"tag"] ) {
         TagSelectionViewController *tvc = [segue destinationViewController];
         tvc.currentMonologue = self.currentMonologue;
     }
     if ( [segue.identifier isEqual: @"edit"] ) {
         EditViewController *evc = [segue destinationViewController];
         evc.text = self.currentMonologue.text;
         evc.title = self.currentMonologue.title;
     }
     if ( [segue.identifier isEqual: @"relatedSegue"] ) {
         
         self.masterlist = [[MonologueMasterlist alloc] init];
         self.masterlist.array = [self.masterlist compileMasterlist:NO];
         
         // replace the usual masterlist.array with a filtered version
         if ([[NSUserDefaults standardUserDefaults] objectForKey:@"settingsList"] != nil) {
             self.masterlist.array = [[MonologueMasterlist filterMonologues:self.masterlist.array] mutableCopy];
         }
         
         int i = 0;
         Monologue *passedMonologue = [[Monologue alloc] init];
         int passedMonologueIndex = 0;
         
         while ( i < self.masterlist.array.count ) {
             Monologue *monologue = self.masterlist.array[i];
             NSString *title = monologue.title;
             if ( [title isEqualToString:self.currentMonologue.title] ) {
                 passedMonologue = monologue;
                 passedMonologueIndex = i;
             }
             i++;
         }
         
         // Get the new view controller using [segue destinationViewController].
         MonologueViewController *mvc = [segue destinationViewController];
         
         // For swipe gesture
         mvc.detailsDataSource = self.masterlist.array;
         // For swipe gesture
         mvc.detailIndex = passedMonologueIndex;
         
         mvc.currentMonologue = passedMonologue;
         
         
         // This keeps the MonologueViewController from skipping any lines in the monologue when accessed from the Browse Screen.
         mvc.edgesForExtendedLayout = UIRectEdgeNone;

         
     }
 }

-(void)segueToBrowseTab {
    // Disable interaction during animation to avoids bugs.
    self.tabBarController.view.userInteractionEnabled = NO;
    
    // Get the views.
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:1] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = 0 > self.tabBarController.selectedIndex;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    [fromView.superview addSubview:fromView];
    
    self.tabBarController.selectedIndex = 0;
    
    // Position it off screen.
    toView.frame = CGRectMake((scrollRight ? (viewSize.size.width *.25) : -(viewSize.size.width * .25 )), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                              
                              [UIView animateWithDuration:0.25
                                               animations: ^{
                                                   // Animate the views on and off the screen.
                                                   [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                                   fromView.frame = CGRectMake(viewSize.size.width * .95, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                                                   toView.frame = CGRectMake((viewSize.origin.x * .90), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                                               }
                               
                                               completion:^(BOOL finished) {
                                                   if (finished) {
                                                       // Begin new animation.
                                                       [UIView animateWithDuration:0.2
                                                                        animations: ^{
                                                                            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                                                                            fromView.frame = CGRectMake(viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                                                                            toView.frame = CGRectMake((viewSize.origin.x), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                                                                        }
                                                                        completion:^(BOOL finished) {
                                                                            if (finished) {
                                                                                // Remove the old view from the tabbar view.
                                                                                [fromView removeFromSuperview];
                                                                                
                                                                                // Restore interaction.
                                                                                self.tabBarController.view.userInteractionEnabled = YES;
                                                                            }
                                                                        }];
                                                   }
                                               }];
}

// For now, monologues are indentified in defaults by title.
// **************************************
// That may have to change in the future.
// **************************************

- (IBAction)favoriteButtonAction:(id)sender {
    [self addFavoriteMonologue];
}

- (IBAction)editButton:(id)sender {
    [self editMonologue];
}

- (IBAction)restoreButton:(id)sender {
    [self restoreMonologue];
}




// These methods will persist in whatever form the app takes.

-(void)addFavoriteMonologue {
    
    NSMutableArray *favoriteMonologues = [[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMonologues"] mutableCopy]];
    
    
    if ( [favoriteMonologues containsObject:self.currentMonologue.title] ) {
        // gray
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-undug"];
        self.favoriteButtonOutlet.tintColor = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
        [favoriteMonologues removeObject:self.currentMonologue.title];
    } else {
        self.favoriteButtonOutlet.image = [UIImage imageNamed:@"dig-dug"];
        self.favoriteButtonOutlet.tintColor = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
        [favoriteMonologues addObject:self.currentMonologue.title];
    }
    
    // Safely save favorite monologues in defaults]
    [[NSUserDefaults standardUserDefaults] setObject:favoriteMonologues forKey:@"favoriteMonologues"];
}

// Go to Edit screen
-(void)editMonologue {
    [self performSegueWithIdentifier:@"edit" sender:self];
}
-(void)addTag {
    [self performSegueWithIdentifier:@"tag" sender:self];
}

// Restore monologue to default.

-(void)restoreMonologue {
    NSLog(@"restoreMonologue");
    NSString *restoreKey = [NSString stringWithFormat:@"%@ restore",self.title];
    NSString *editKey = [NSString stringWithFormat:@"%@ edit",self.title];
    self.currentMonologue.text = [[NSUserDefaults standardUserDefaults] objectForKey:restoreKey];
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:restoreKey];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:editKey];
    
    self.editArray = nil;
    self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", nil];
    [self maintainView];
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
                         }];
    } else {
        self.barsHidden = 2;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.navigationController.navigationBarHidden = NO;
                         }];
    }
    NSLog(@"self.barsHidden is %d",self.barsHidden);
}

- (BOOL)prefersStatusBarHidden {
    if ( self.barsHidden == 1 ) {
        return YES;
    } else {
        return NO;
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
                             self.currentMonologue = [self.detailsDataSource objectAtIndex:self.detailIndex];
                             [self loadData];
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
                                                  }}];}}];
}


-(void)compileRelatedMonologues {
    relatedMonologues = [[NSMutableArray alloc] init];
    // relatedMonologuesDictionary will store the number of matches each monologue has to the current monologue
    // under the key: "%@ %d", comparativeMonologue.title, numberOfMatches
    
    self.masterlist = [[MonologueMasterlist alloc] init];
    self.masterlist.array = [self.masterlist compileMasterlist:NO];
    // replace the usual masterlist.array with a filtered version
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"settingsList"] != nil) {
        self.masterlist.array = [[MonologueMasterlist filterMonologues:self.masterlist.array] mutableCopy];
    }
    int i = 0;
    while ( i < self.masterlist.array.count ) {
        int matches = 0;
        Monologue *comparativeMonologue = [self.masterlist.array objectAtIndex:i];
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
            [relatedMonologues addObject:comparativeMonologue];
        }
        
        i++;
    }
    
    NSMutableArray *sortedRelatedMonologues;
    sortedRelatedMonologues = [[relatedMonologues sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
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
    relatedMonologues = [sortedRelatedMonologues mutableCopy];
    
    // In case there are no related monologues
    if ( relatedMonologues.count == 0 ) {
        Monologue *nullMonologue = [[Monologue alloc] init];
        nullMonologue.title = @"No related monologues";
        nullMonologue.authorFirst = @"For this";
        nullMonologue.authorLast = @"monologue, anyway";
        nullMonologue.text =@"Go figure";
        [relatedMonologues addObject:nullMonologue];
    }
    
}


-(NSString*)excerptLabelFilter:(NSString *)targetString {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString: targetString];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"[" intoString:NULL] ;
        [theScanner scanUpToString:@"]" intoString:&text] ;
        targetString = [targetString stringByReplacingOccurrencesOfString:
                        [NSString stringWithFormat:@"%@]", text] withString:@""];
    }
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@" "];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n\n" withString:@" "];
    targetString = [targetString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return targetString;
}




// These two methods can store the favoriteMonologues array in defaults
// even though it contains a custom object
//
// If the array saves the title instead of the whole object though,
// these methods may be entirely unnecessary.

- (void)saveCustomObject:(NSMutableArray *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


@end
