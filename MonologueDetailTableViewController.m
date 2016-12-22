//
//  MonologueDetailTableViewController.m
//  monologues
//
//  Created by TerryTorres on 7/7/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "MonologueDetailTableViewController.h"

#define numberOfSections 2
#define monologueText 0
#define monologueNotes 1

@interface MonologueDetailTableViewController ()

@end

@implementation MonologueDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
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
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"in cellFoRowAtIndexPath");
    UITableViewCell *cell;
    switch ( indexPath.section ) {
            NSLog(@"switch case");
        case monologueText:
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            cell.textLabel.text = self.currentMonologue.text;
            NSLog(@"self.currentMonologue.text is %@",self.currentMonologue.text);
            break;
        case monologueNotes:
            cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell" forIndexPath:indexPath];
            cell.textLabel.text = self.currentMonologue.notes;
            NSLog(@"self.currentMonologue.notes is %@",self.currentMonologue.notes);
            break;
        default:
            return 0;
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [cell sizeToFit];
    // Configure the cell...
    
    return cell;
}

// Set cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText;
    switch ( indexPath.section ) {
            NSLog(@"switch case");
        case monologueText:
            cellText = self.currentMonologue.text;
            break;
        case monologueNotes:
            cellText = self.currentMonologue.notes;
            break;
        default:
            return 0;
    }
    UIFont *cellFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]
     initWithString:cellText attributes:@ { NSFontAttributeName: cellFont}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesDeviceMetrics
                                               context:nil];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.text = cellText;
    // label.numberOfLines = 0;
    
    CGSize maxSize = CGSizeMake(200.0f, CGFLOAT_MAX);
    CGSize requiredSize = [textView sizeThatFits:maxSize];
    textView.frame = CGRectMake(10, 10, maxSize.width, requiredSize.height);
    
    // [label sizeToFit];
    
    
    return rect.size.height;

}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
