//
//  TabBarController.m
//  Yorick
//
//  Created by TerryTorres on 11/12/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDelegate:self];
}

-(void)awakeFromNib {
    [super awakeFromNib];

    self.tabBar.barTintColor = [YorickStyle color1];
    self.tabBarController.selectedViewController.navigationController.navigationBar.translucent = NO;
    self.tabBar.translucent = NO;
    
    // For Tab bar buttons
    self.tabBar.tintColor = [YorickStyle color1];
    
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    
    
    [tabBarItem0 setImage: [[UIImage imageNamed:@"favorites-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setSelectedImage: [[UIImage imageNamed:@"favorites-selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setImage: [[UIImage imageNamed:@"browse-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage: [[UIImage imageNamed:@"browse-selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setImage: [[UIImage imageNamed:@"filters-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage: [[UIImage imageNamed:@"filters-selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    
    [tabBarItem0 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color3] }
                               forState:UIControlStateNormal];
    [tabBarItem0 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color2] }
                               forState:UIControlStateSelected];
    [tabBarItem1 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color3] }
                               forState:UIControlStateNormal];
    [tabBarItem1 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color2] }
                               forState:UIControlStateSelected];
    [tabBarItem2 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color3] }
                               forState:UIControlStateNormal];
    [tabBarItem2 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color2] }
                               forState:UIControlStateSelected];

}

- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    self.indexOfNewTab = [[theTabBar items] indexOfObject:item];
    if ( self.indexOfNewTab == self.selectedIndex ) {
        [self scrollToTop];
    }
}

-(void)scrollToTop {
    if (self.indexOfNewTab == 1) {
        NavigationController *nc = [self.viewControllers objectAtIndex:1];
        MonologueViewController *vc = [nc.viewControllers objectAtIndex:0];
        [vc.tableView setContentOffset:CGPointMake(0, 0 - vc.tableView.contentInset.top) animated:YES];
    }
}

// Called when screen is tapped on detail views.
- (void)hideTabBar {
    UITabBar *tabBar = self.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    
    CGRect tabFrame = tabBar.frame;
    tabFrame.origin.y += tabBar.frame.size.height;
    tabBar.frame = tabFrame;
    
    CGRect parentFrame = parent.frame;
    parentFrame.size.height += tabFrame.size.height;
    parent.frame = parentFrame;
    
}

- (void)showTabBar {
    UITabBar *tabBar = self.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    
    CGRect tabFrame = tabBar.frame;
    tabFrame.origin.y -= tabBar.frame.size.height;
    tabBar.frame = tabFrame;
    
    CGRect parentFrame = parent.frame;
    parentFrame.size.height -= tabFrame.size.height;
    parent.frame = parentFrame;

}

@end
