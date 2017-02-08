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
    [super viewDidLoad];
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tagSearchFromFavorites:)
                                                 name:@"tagSearchFromFavorites"
                                               object:nil];
    self.title = @"Boneyard";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkUpdates];
}

-(void) checkUpdates {
    NSLog(@"checkUpdates");
    NSString *strURL = [NSString stringWithFormat:@"http://www.terry-torres.com/yorick/api/api.php?method=checkUpdates"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    //
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"checkUpdates Connection begin");
                               
                               if (connectionError) {
                                   NSLog(@"connection error");
                               } else if (response != nil) {
                                   
                                   // receive returned value
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
    __block NSMutableArray *localMonologues = self.manager.monologues;
    NSMutableArray *updatedMonologues = [[NSMutableArray alloc] init];
    
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
                                   
                                   // Access plist on device an replace old monologues with updatedMonologues.
                                   // Put in an IF statement for monologues with new titles and new ids.
                                   
                                   NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                   documentPath = [documentPath stringByAppendingPathComponent:@"monologueList.plist"];
                                
                                   
                                   NSMutableDictionary* newMonologueDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:documentPath];
                                   NSMutableArray *keys = [[newMonologueDictionary allKeys]mutableCopy];
                                   NSLog(@"keys.count on load is %lu",(unsigned long)keys.count);
                                   
                                   for (int i = 0; i < localMonologues.count; i++) {
                                       Monologue *localMonologue = localMonologues[i];
                                       for (int ii = 0; ii < updatedMonologues.count; ii++) {
                                           Monologue *updatedMonologue = updatedMonologues[ii];
                                           if ( [localMonologue.title isEqualToString:updatedMonologue.title] ) {
                                               localMonologue = updatedMonologue;
                                           }
                                       }
                                   }
                                   
                                   [self.manager addTagsFromArrayOfMonologues:updatedMonologues];
                                   self.manager.latestUpdateCount = updatedMonologues.count;
                                   
                                   NSLog(@"here we go!!");
                                   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                       [self updateDisplayArrayForFilters];
                                       [self.tableView reloadData];
                                       [self setHeaderTitle];
                                       NSLog(@"Connection complete");
                                   }];
                                   
                               }}];


}


- (void)tagSearchFromFavorites:(NSNotification*)notification
{
    NSString *searchText = [notification.userInfo objectForKey:@"tag"];;
    self.searchController.searchBar.text = searchText;
    
}



@end
