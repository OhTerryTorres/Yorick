//
//  NavigationController.m
//  monologues
//
//  Created by TerryTorres on 11/12/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    // Sets color scheme
    UIColor *color1 = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
    
    
    [[UINavigationBar appearance] setBarTintColor:color1];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color2,}];
    
    // This changes the color of the back button item, and possibly other items.
    [self.navigationBar setTintColor:color2];
    //self.navigationBar.translucent = NO;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
