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
        // *** iPad code
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
            cell.textLabel.font = [UIFont systemFontOfSize:37];
        }
        [cell.textLabel setTextColor:[YorickStyle color2]];
        cell.userInteractionEnabled = YES;
    } else if ( indexPath.section == monologueRelated ) {
        Monologue *currentMonologue = [self getRelatedMonologueForIndexPath:indexPath];
        
        return currentMonologue.cell;
        
    } else if ( indexPath.section == monologueEdit ) {
        NSString *currentEdit = [self.editArray objectAtIndex:indexPath.row];
        cell.textLabel.text = currentEdit;
        // *** iPad code
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
            cell.textLabel.font = [UIFont systemFontOfSize:37];
        }
        [cell.textLabel setTextColor:[YorickStyle color2]];

        cell.userInteractionEnabled = YES;
    } else {
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
    
    return cell;
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
            // *** iPad code
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
                size.height *= 0.5;
            }
            break;
        case monologueNotes:
            [self configureCell:self.prototypeCellNotes forRowAtIndexPath:indexPath];
            [self.prototypeCellNotes setNeedsLayout];
            size = [self.prototypeCellNotes.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            break;
        case monologueTags:
            [self configureCell:self.prototypeCellTags forRowAtIndexPath:indexPath];
            [self.prototypeCellTags layoutIfNeeded];
            size = [self.prototypeCellTags.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            // *** iPad code
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
                size.height *= 2;
            }
            break;
        case monologueEdit:
            size = [self.prototypeCellEdit.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            // *** iPad code
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
                size.height *= 2;
            }
            //Attemp to keep a buffer zone at the bottom.
            size.height += (size.height*.1);
            break;
        default:
            size.height = [self.tableView rowHeight];
            break;
    }
    
    return size.height+1;
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
