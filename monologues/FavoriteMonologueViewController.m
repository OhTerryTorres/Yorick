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


// unwind segues
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

-(void)setUpHeaderTitle {
    self.navigationItem.title = @"Favorites";
}

-(void)updateData2 {
    NSArray* tempSource = [[NSArray alloc] initWithArray:self.detailsDataSource];
    self.detailsDataSource = [self.manager filterMonologuesForSettings:self.manager.monologues];
    self.relatedMonologues = [self findMonologuesRelatedToMonologue:self.currentMonologue inArrayOfMonologues:self.detailsDataSource];
    self.detailsDataSource = tempSource;
    [self setUpEditOptions];
}

// This also alters available edit options
-(void)setUpEditOptions {
    Monologue* comparativeMonologue = [self.manager getMonologueForIDNumber:self.currentMonologue.idNumber];
    if ( ![comparativeMonologue.text isEqualToString:self.currentMonologue.text] ) {
        self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", @"Restore", nil];
    } else {
        self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", nil];
    }
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
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case monologueText:
            return self.textArray.count;
            break;
        case monologueTags:
            return self.tagsArray.count;
            break;
        case monologueRelated:
            if ( self.relatedMonologues.count > 3) {
                return 3;
            } else {
                return self.relatedMonologues.count;
            }
            break;
        case monologueEdit:
            return self.editArray.count;
            break;
        default:
            return 1;
    }

}


// Several steps need to be taken so that each piece of data from the current monologue is displayed properly.
// Each section requires its own cell indentifier to start the process
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *currentTag = @"";
    Monologue *relatedMonologue;
    NSString *currentEdit = @"";
    
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
        case monologueEdit:
            self.editCell = [tableView dequeueReusableCellWithIdentifier:@"edit"];
            currentEdit = self.editArray[indexPath.row];
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
            size = [self sizeForTextCellAtIndexPath:indexPath];
            break;
        case monologueNotes:
            size = [self sizeForNotesCellAtIndexPath:indexPath];
            break;
        case monologueTags:
            size = [self sizeForTagsCellAtIndexPath:indexPath];
            break;
        case monologueEdit:
            size = [self sizeForEditCellAtIndexPath:indexPath];
            break;
        default:
            size.height = [self.tableView rowHeight];
            break;
    }
    
    return size.height+1;
}
-(CGSize)sizeForEditCellAtIndexPath:(NSIndexPath*)indexPath {
    self.editCell.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.editCell.textLabel.bounds);
    return [self.editCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}


// For helping in searching for tags in the Browse screen
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    // Dealing with tags
    // This will perform a tag search in the Browse screen.
    if ( indexPath.section == monologueTags ) {
        NSString *t = self.tagsArray[path.row];
        NSString *tag = [NSString stringWithFormat:@"!%@",t];
        [self.tabBarController setSelectedIndex:1];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"tagSearchFromFavorites" object:nil userInfo:@{@"tag": tag}];
        
    }
    
    // Dealing with edit options
    if ( indexPath.section == monologueEdit ) {
        NSString *e = self.editArray[path.row];
        if ( [e isEqual:@"Add Tag"] ) {
            [self addTag];
        } else if ( [e isEqual:@"Edit"] ) {
            [self editMonologue];
        } else if ( [e isEqual:@"Restore"] ) {
            [self restoreMonologue];
        }
    }
    
    // Selecting a related monologue
    if ( indexPath.section == monologueRelated ) {
        [self loadRelatedMonologueForIndexPath:indexPath];
    }

}


 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

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
    self.textArray = [self splitTextIntoArray:self.currentMonologue.text];
    self.editArray = [NSArray arrayWithObjects:@"Add Tag", @"Edit", nil];
    
    PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Monologue Restored"];
    [self.tabBarController.view addSubview:popUp];
    // Reload text section
    [self.tableView reloadData];
}


@end
