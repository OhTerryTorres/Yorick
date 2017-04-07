//
//  TagSelectionViewController.m
//  Yorick
//
//  Created by TerryTorres on 5/14/15.
//  Copyright (c) 2015 Terry Torres. All rights reserved.
//

#import "TagSelectionViewController.h"

@interface TagSelectionViewController ()

@end

@implementation TagSelectionViewController


#pragma mark: View Changing Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    self.navigationBar.tintColor = [YorickStyle color1];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ( ![[NSUserDefaults standardUserDefaults] boolForKey:@"didAcceptEULA"] ) {
        [self presentEULA];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark: Display Setup

-(void)presentEULA {
    NSString *EULA = [NSString stringWithFormat:@"Thank you for taking an active role in Yorick's upkeep. In doing so, you are accepting these terms regarding user-generated content:\n\n1) You retain copyright status of any content uploaded, while also granting perpetual, irrevocable non-transferable license for use of such content to Team Yorick.\n\n2) Yorick screens for objectionable content. If you persist in attempting to upload objectionable content, Team Yorick has the right to restrict you from making any additional tags. Objectionable content includes that which is obscene, profane, or defamatory."];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Updating Yorick" message:EULA delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 1;
    [alert show];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark: TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.manager.allTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if ( indexPath.row == 0 ) {
        cell.textLabel.text = @"+ new tag";
    } else if ( indexPath.row >= 1 ) {
    cell.textLabel.text = self.manager.allTags[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *c = self.manager.allTags[indexPath.row];
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"didAcceptEULA"] ) {
        if ( [cell.textLabel.text rangeOfString:@"new tag"].location != NSNotFound ) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add a tag" message:@"Add a tag that acts as a desciption, action, subject, etc." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Submit", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 0;
            [alert show];
        } else {
            if ( [self.currentMonologue.tags rangeOfString:c].location != NSNotFound ) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"The monologue already has this tag. Try another." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = 4;
                [alert show];
            } else
                [self updateTags:c];
        }
    }
    
}


#pragma mark: AlertView Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ( alertView.tag == 1 ) {
        if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:(BOOL)YES forKey:@"didAcceptEULA"];
        }
        if (buttonIndex == 0) {
            [self performSegueWithIdentifier:@"cancelTag" sender:self];
        }
    }
    
    if ( alertView.tag == 0 ) {
        if (buttonIndex == 1) {
            NSString *customTag = [[alertView textFieldAtIndex:0] text];
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" -/:;()$&@\".,!?\'[]{}#%^*+=_|~<>€£¥•."];
            NSMutableArray *bannedWords = [[NSMutableArray alloc] initWithObjects:@"bad", @"words", @"here", nil];
            if ( [customTag rangeOfCharacterFromSet:doNotWant].location != NSNotFound ) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Try again without special characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = 2;
                [alert show];
            }
            BOOL badWords = NO;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"This is a bad tag. Even Shakespeare would be ashamed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 3;
            int i = 0;
            while ( i < bannedWords.count && badWords == NO ) {
                if ([customTag rangeOfString:bannedWords[i]].location != NSNotFound ) {
                    badWords = YES;
                }
                i++;
            }
            if (badWords == YES) {
                [alert show];
            }
            if (badWords == NO) {
                if ( [self.currentMonologue.tags rangeOfString:customTag].location != NSNotFound ) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"The monologue already has this tag. Try another." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alert.tag = 4;
                    [alert show];
                } else
                [self updateTags:customTag];
            }
        }
    }
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark: Connection Methods

-(void)updateTags:(NSString*)tag {
    // Call API to select the appropriate monologe and add the tag
    if ( tag != nil ) {
        self.currentMonologue.tags = [self.currentMonologue.tags stringByAppendingString:[NSString stringWithFormat:@" !%@",tag]];
        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSString *safeNotes = [self.currentMonologue.notes stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        safeNotes = [safeNotes stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        safeNotes = [safeNotes stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        NSString *safeText = [self.currentMonologue.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        safeText = [safeText stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        safeText = [safeText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        NSString *safeTitle = [self.currentMonologue.title stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        safeTitle = [safeTitle stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        safeTitle = [safeTitle stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        // Transfer monologue values and UUID via php
        NSString *strURL = @"http://www.terry-torres.com/yorick/api/api.php?method=updateMonologue";
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
        [request setHTTPMethod:@"POST"];
        NSString *body = [NSString stringWithFormat:@"{\"id\":\"%d\",\"uuid\":\"%@\",\"age\":\"%@\",\"authorFirst\":\"%@\",\"authorLast\":\"%@\",\"character\":\"%@\",\"gender\":\"%@\",\"length\":\"%@\",\"notes\":\"%@\",\"period\":\"%@\",\"text\":\"%@\",\"title\":\"%@\",\"tags\":\"%@\",\"tone\":\"%@\"}",self.currentMonologue.idNumber,uuid,self.currentMonologue.age,self.currentMonologue.authorFirst,self.currentMonologue.authorLast,self.currentMonologue.character,self.currentMonologue.gender,self.currentMonologue.length,safeNotes,self.currentMonologue.period,safeText,safeTitle,self.currentMonologue.tags,self.currentMonologue.tone];
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.tableView.userInteractionEnabled = NO;
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSLog(@"updateTags Connection begin");
                                   
                                   if (connectionError) {
                                       NSLog(@"connection error");
                                       UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                       [alert show];
                                       [self performSegueWithIdentifier:@"cancelTag" sender:self];
                                   } else if (response != nil) {
                                       
                                       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                           
                                           NSLog(@"add tag successful");
                                           
                                           NSString *strResults = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                           NSLog(@"%@", strResults);

                                           self.manager.latestUpdateCount++;

                                           [self performSegueWithIdentifier:@"saveTag" sender:self];
                                           
                                           NSLog(@"Connection complete");
                                       }];
                                       
                                   }
                                   
                               self.tableView.userInteractionEnabled = YES;
                               
                               }];
    }
}


@end
