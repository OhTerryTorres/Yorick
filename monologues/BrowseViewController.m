//
//  FirstViewController.m
//  monologues
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController

// unwind segue
- (IBAction)searchTag:(UIStoryboardSegue *)segue {}

- (void)viewDidLoad
{
    self.title = @"All Monologues";
    [super viewDidLoad];
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tagSearchFromFavorites:)
                                                 name:@"tagSearchFromFavorites"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkUpdates];
}

// Yorick accesses a MySQL database that contains a table of monologue entries much like those in monologueList.plist.
// The entries in the table are use to replace older versions of the same monolouge on the device.
// This is how user-defined tags are updated, but it's also use to fix typoes or reclassifcations.
-(void) checkUpdates {
    NSLog(@"checkUpdates");
    NSString *strURL = [NSString stringWithFormat:@"http://www.terry-torres.com/yorick/api/api.php?method=checkUpdates"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"checkUpdates Connection begin");
                               
                               if (connectionError) {
                                   NSLog(@"connection error");
                               } else if (response != nil) {
                                   
                                   NSString *strResults = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   int databaseUpdateCount = [strResults intValue];

                                   if ( self.manager.latestUpdateCount != databaseUpdateCount ) {
                                       NSLog(@"updates on device is %d",self.manager.latestUpdateCount);
                                       NSLog(@"updates in database is %d", [strResults intValue]);
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                UIBarButtonItem *updateButton = [[UIBarButtonItem alloc]
                                                                          initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                          target:self
                                                                          action:@selector(updateMonologues:)];
                                                self.navigationItem.rightBarButtonItem = updateButton;
                                            }];
                                   }
                                   NSLog(@"Update check complete");
                               }}];
}

-(IBAction)updateMonologues:(id)sender {
    NSLog(@"in updateMonologues");
    NSString *strURL = [NSString stringWithFormat:@"http://www.terry-torres.com/yorick/api/api.php?method=getUpdates"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    //
    
    __block NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"updateMonologues Connection begin");
                               
                               if (connectionError) {
                                   NSLog(@"error");
                               } else if (response != nil) {
                                   
                                   jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
                                   NSLog(@"updateMonologues Async JSON: %@", jsonArray);
                                   
                                   NSMutableArray *updatedMonologues = [[NSMutableArray alloc] init];
                                   
                                   // Loop through JSON array
                                   for ( int i = 0; i < jsonArray.count; i++ ) {
                                       Monologue* monologue = [[Monologue alloc] initWithidNumber:[[[jsonArray objectAtIndex:i] objectForKey:@"id"]intValue]
                                                                                           title:[[jsonArray objectAtIndex:i] objectForKey:@"title"]
                                                                                     authorFirst:[[jsonArray objectAtIndex:i] objectForKey:@"authorFirst"]
                                                                                      authorLast:[[jsonArray objectAtIndex:i] objectForKey:@"authorLast"]
                                                                                       character:[[jsonArray objectAtIndex:i] objectForKey:@"character"]
                                                                                            text:[[jsonArray objectAtIndex:i] objectForKey:@"text"]
                                                                                          gender:[[jsonArray objectAtIndex:i] objectForKey:@"gender"]
                                                                                            tone:[[jsonArray objectAtIndex:i] objectForKey:@"tone"]
                                                                                          period:[[jsonArray objectAtIndex:i] objectForKey:@"period"]
                                                                                             age:[[jsonArray objectAtIndex:i] objectForKey:@"age"]
                                                                                          length:[[jsonArray objectAtIndex:i] objectForKey:@"length"]
                                                                                           notes:[[jsonArray objectAtIndex:i] objectForKey:@"notes"]
                                                                                             tags:[[jsonArray objectAtIndex:i] objectForKey:@"tags"]];
                                       
                                       [updatedMonologues addObject:monologue];

                                   }
                                   // receive returned value
                                   NSString *strResults = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"%@", strResults);
                                   
                                   [self.manager updateMonologuesWithArrayOfMonologues:updatedMonologues];
                                   self.manager.latestUpdateCount = (int)updatedMonologues.count;
                                   
                                   NSLog(@"here we go!!");
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                       self.navigationItem.rightBarButtonItem = nil;
                                       [self.manager addTagsFromArrayOfMonologues:updatedMonologues];
                                       
                                       [self updateDisplayArrayForFilters];
                                       [self.tableView reloadData];
                                       //[self setHeaderTitle];
                                       NSLog(@"Connection complete");
                                       
                                       PopUpView* popUp = [[PopUpView alloc] initWithTitle:@"Library Updated"];
                                       [self.tabBarController.view addSubview:popUp];
                                   }];
                                   
                               }}];


}


- (void)tagSearchFromFavorites:(NSNotification*)notification
{
    NSString *searchText = [notification.userInfo objectForKey:@"tag"];;
    self.searchController.searchBar.text = searchText;
    
}



@end
