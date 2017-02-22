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

@implementation FavoriteMonologueViewController 


//THIS allows for unwind segues, would should save time and space.
- (IBAction)cancelEdit:(UIStoryboardSegue *)segue {}
- (IBAction)saveEdit:(UIStoryboardSegue *)segue {
    PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Monolouge Updated"];
    [self.tabBarController.view addSubview:popUp];
}
- (IBAction)cancelTag:(UIStoryboardSegue *)segue {}
- (IBAction)saveTag:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
    PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Tags Updated"];
    [self.tabBarController.view addSubview:popUp];
}


#pragma mark: OVERRIDING SUPERCLASS METHODS

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.tagsArray = [self loadTagsIntoArray:self.currentMonologue.tags];
        NSArray* tempSource = [[NSArray alloc] initWithArray:self.detailsDataSource];
        self.detailsDataSource = [self.manager filterMonologuesForSettings:self.manager.monologues];
        [self compileRelatedMonologuesfromArrayOfMonologues: self.detailsDataSource];
        self.detailsDataSource = [[NSArray alloc] initWithArray:tempSource];
        [self setUpEditOptions];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self loadHeaderTitle];
            [self setFavoriteStatus];
        });
    });
}

-(void)loadHeaderTitle {
    // This displays the amount of monologues currently in the list
    // +1 to adjust for the zero index
    NSString *headerTitle = [NSString stringWithFormat:@"Digs (%lu/%lu)",self.detailIndex+1,(unsigned long)self.detailsDataSource.count];
    [self.navigationItem setTitle:headerTitle];
}

// This also alters available edit options
-(void)setUpEditOptions {
    Monologue* comparativeMonologue = [self.manager getMonologueForIDNumber:self.currentMonologue.idNumber];
    if ( ![comparativeMonologue.text isEqualToString:self.currentMonologue.text] ) {
        self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", @"Restore", nil];
    } else {
        self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", nil];
    }
    [self.tableView reloadData];
}

#pragma mark: OVERRIDING TableView METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // Defined at the top
    return numberOfSections;
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
        if ( self.relatedMonologues.count > 3) {
            return 3;
        } else {
            return self.relatedMonologues.count;
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    Setting *sizeSetting = self.manager.settings[3];
    NSString *textSizeString = sizeSetting.currentSetting;
    NSString *currentTag = @"";
    Monologue *relatedMonologue = [[Monologue alloc] init];
    NSString *currentEdit = @"";
    
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"related"];
            relatedMonologue = [self getRelatedMonologueForIndexPath:indexPath];
            if ([relatedMonologue.title isEqualToString:@"No related monologues"]) {
                relatedMonologue.cell.userInteractionEnabled = false;
            }
            cell = relatedMonologue.cell;
            break;
        case monologueEdit:
            self.editCell = [tableView dequeueReusableCellWithIdentifier:@"edit"];
            currentEdit = [self.editArray objectAtIndex:indexPath.row];
            self.editCell.textLabel.text = currentEdit;
            [self.editCell.textLabel setTextColor:[YorickStyle color2]];
            self.editCell.userInteractionEnabled = YES;
            cell = self.editCell;
            break;
        default:
            break;
    }
    
    return cell;
    
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
            self.notesCell.notesLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.notesCell.textLabel.frame);
            size = [self.notesCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        case monologueTags:
            [self.tagCell.contentView setNeedsLayout];
            [self.tagCell.contentView layoutIfNeeded];
            self.tagCell.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tagCell.textLabel.frame);
            size = [self.tagCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        case monologueEdit:
            [self.editCell.contentView setNeedsLayout];
            [self.editCell.contentView layoutIfNeeded];
            self.editCell.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.editCell.textLabel.bounds);
            size = [self.editCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        default:
            size.height = [self.tableView rowHeight];
            break;
    }
    
    return size.height+1;
}


// For helping in searching for tags in the Browse screen
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    // Dealing with tags
    // This will perform a tag search in the Browse screen.
    if ( indexPath.section == monologueTags ) {
        NSString *c = self.tagsArray[path.row];
        NSString *tag = [NSString stringWithFormat:@"!%@",c];
        NSLog(@"tag in Favorites is %@",tag);
        [self.tabBarController setSelectedIndex:1];
        [self passManagerToAppDelegate];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"tagSearchFromFavorites" object:nil userInfo:@{@"tag": tag}];
        
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
        [self monologueTransitionForIndexPath:indexPath];
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
         tvc.manager = self.manager;
         tvc.currentMonologue = self.currentMonologue;
     }
     if ( [segue.identifier isEqual: @"edit"] ) {
         EditViewController *evc = [segue destinationViewController];
         evc.manager = self.manager;
         evc.currentMonologue = self.currentMonologue;
         evc.title = self.currentMonologue.title;
     }
     if ( [segue.identifier isEqual: @"relatedSegue"] ) {
         
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         
         Monologue *passedMonologue = self.relatedMonologues[path.row];
         
         // Get the new view controller using [segue destinationViewController].
         MonologueViewController *mvc = [segue destinationViewController];
         
         // For swipe gesture
         mvc.detailsDataSource = [self.manager filterMonologuesForSettings:self.manager.monologues];
         
         int i = 0;
         for (Monologue* monologue in mvc.detailsDataSource) {
             if( monologue.idNumber == passedMonologue.idNumber ) {
                 mvc.detailIndex = i;
                 break;
             }
             i++;
         }
         
         mvc.currentMonologue = passedMonologue;
         
         // This keeps the MonologueViewController from skipping any lines in the monologue when accessed from the Browse Screen.
         mvc.edgesForExtendedLayout = UIRectEdgeNone;

     }
 }


#pragma mark: User Interaction

- (IBAction)favoriteButtonAction:(id)sender {
    [self addMonologueToFavorites];
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
    self.currentMonologue = [[self.manager getMonologueForIDNumber:self.currentMonologue.idNumber] copy];
    
    self.editArray = nil;
    self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", nil];
    [self maintainView];
    
    PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Monologue Restored"];
    [self.tabBarController.view addSubview:popUp];
}


@end
