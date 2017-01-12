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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    self.navigationBar.tintColor = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
    
    self.allTags = [[NSMutableArray alloc] init];
    self.allTags = [[NSUserDefaults standardUserDefaults] objectForKey:@"allTags"];
    
    // *********
    // Sort tags alphabetically
    // **********
    
    self.allTags = [[self.allTags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    NSLog(@"FUCK allTags.count is %lu",(unsigned long)self.allTags.count);
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.allTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if ( indexPath.row == 0 ) {
        cell.textLabel.text = @"+ new tag";
    } else if ( indexPath.row >= 1 ) {
    cell.textLabel.text = [self.allTags objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *c = self.allTags[indexPath.row];
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"didAcceptEULA"] ) {
        if ( [cell.textLabel.text rangeOfString:@"new tag"].location != NSNotFound ) {
            NSLog(@"SCHWING");
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
            NSMutableArray *bannedWords = [[NSMutableArray alloc] initWithObjects:@"fuck", @"shit", @"fuk", @"fuk", @"fag",@"faggot",@"faggo",@"nigger",@"nigga",@"cunt",@"asshole",@"bullshit",@"chink",@"christ",@"clit",@"cock",@"coon",@"cum",@"dick",@"dyke",@"gook",@"heeb",@"pussy",@"jizz",@"kike",@"poontang",@"spic",@"skeet",@"wetback", nil];
            if ( [customTag rangeOfCharacterFromSet:doNotWant].location != NSNotFound ) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Try again without special characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = 2;
                [alert show];
            }
            BOOL badWords = NO;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"There are some bad words in here. Even Shakespeare would be ashamed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 3;
            int i = 0;
            while ( i < bannedWords.count && badWords == NO ) {
                if ([customTag rangeOfString:bannedWords[i]].location != NSNotFound ) {
                    badWords = YES;
                }
                i++;
            }
            if (badWords == YES) {
                NSLog(@"badWords YES");
                [alert show];
            }
            if (badWords == NO) {
                NSLog(@"badWords NO");
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

-(void)presentEULA {
    NSString *EULA = [NSString stringWithFormat:@"Thank you for taking an active role in Yorick's upkeep. In doing so, you are accepting these terms regarding user-generated content:\n\n1) You retain copyright status of any content uploaded, while also granting perpetual, irrevocable non-transferable license for use of such content to Team Yorick.\n\n2) Yorick screens for objectionable content. If you persist in attempting to upload objectionable content, Team Yorick has the right to restrict you from making any additional tags. Objectionable content includes that which is obscene, profane, or defamatory."];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Updating Yorick" message:EULA delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 1;
    [alert show];
}

-(void)updateTags:(NSString*)tag {
    // This uploads the default text, and not the user's edited version
    NSString *restoreKey = [NSString stringWithFormat:@"%@ restore",self.currentMonologue.title];
    NSLog(@"restoreKey in tags is %@",restoreKey);
    NSString *restoreText = [[NSUserDefaults standardUserDefaults] objectForKey:restoreKey];
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:restoreKey] ) {
        self.currentMonologue.text = restoreText;
        NSLog(@"restoreText in tags is %@",restoreText);
    }
    
    // Call php file to select the appropriate monologe and add the tag
    if ( tag != nil ) {
        self.currentMonologue.tags = [self.currentMonologue.tags stringByAppendingString:[NSString stringWithFormat:@" !%@",tag]];
        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSString *safeNotes = [self.currentMonologue.notes stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        safeNotes = [safeNotes stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        safeNotes = [safeNotes stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        NSString *safeText = [self.currentMonologue.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        safeText = [safeText stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        safeText = [safeNotes stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        // Transfer monologue values and UUID via php
        NSLog(@"in updateTags");
        NSString *strURL = @"http://www.terry-torres.com/yorick/api/api.php?method=updateMonologue";
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
        [request setHTTPMethod:@"POST"];
        NSString *body = [NSString stringWithFormat:@"{\"id\":\"%@\",\"uuid\":\"%@\",\"age\":\"%@\",\"authorFirst\":\"%@\",\"authorLast\":\"%@\",\"character\":\"%@\",\"gender\":\"%@\",\"length\":\"%@\",\"notes\":\"%@\",\"period\":\"%@\",\"text\":\"%@\",\"title\":\"%@\",\"tags\":\"%@\",\"tone\":\"%@\"}",self.currentMonologue.idNumber,uuid,self.currentMonologue.age,self.currentMonologue.authorFirst,self.currentMonologue.authorLast,self.currentMonologue.character,self.currentMonologue.gender,self.currentMonologue.length,safeNotes,self.currentMonologue.period,safeText,self.currentMonologue.title,self.currentMonologue.tags,self.currentMonologue.tone];
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
                                       NSLog(@"response");
                                       NSMutableDictionary *currentMonologueDictionary = [[NSMutableDictionary alloc] init];
                                       [currentMonologueDictionary setObject:self.currentMonologue.idNumber forKey:@"id"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.title forKey:@"title"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.authorFirst forKey:@"authorFirst"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.authorLast forKey:@"authorLast"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.character forKey:@"character"];
                                       
                                       [currentMonologueDictionary setObject:self.currentMonologue.text forKey:@"text"];
                                       
                                       [currentMonologueDictionary setObject:self.currentMonologue.gender forKey:@"gender"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.tone forKey:@"tone"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.period forKey:@"period"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.age forKey:@"age"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.length forKey:@"length"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.notes forKey:@"notes"];
                                       [currentMonologueDictionary setObject:self.currentMonologue.tags forKey:@"tags"];
                                       
                                       NSString *strResults = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       
                                       NSLog(@"strResults is %@",strResults);
                                       
                                       NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                       documentPath = [documentPath stringByAppendingPathComponent:@"monologueList.plist"];
                                       
                                       NSMutableDictionary *monologueDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:documentPath];
                                       
                                       NSString *keyString = [currentMonologueDictionary objectForKey:@"id"];
                                       [monologueDictionary setObject:currentMonologueDictionary forKey:keyString];
                                       
                                       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                           
                                           NSLog(@"add operation");
                                           
                                           [monologueDictionary writeToFile:documentPath atomically:YES];
                                           
                                           
                                           unsigned long updates = [[NSUserDefaults standardUserDefaults] integerForKey:@"updates"] + 1;
                                           
                                           
                                           [[NSUserDefaults standardUserDefaults] setInteger:updates forKey:@"updates"];
                                           
                                           [self performSegueWithIdentifier:@"saveTag" sender:self];
                                           
                                           NSLog(@"Connection complete");
                                       }];
                                       
                                   }
                                   
                               self.tableView.userInteractionEnabled = YES;
                               
                               }];
    }
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    FavoriteMonologueViewController *fvc = [segue destinationViewController];
    fvc.currentMonologue = self.currentMonologue;
}


@end
