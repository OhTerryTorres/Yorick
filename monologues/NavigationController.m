//
//  NavigationController.m
//  Yorick
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
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    // This changes the color of the back button item, and other potential items.
    [self.navigationBar setTintColor:[YorickStyle color1]];
    self.view.backgroundColor = [YorickStyle color3];
    
}



@end
