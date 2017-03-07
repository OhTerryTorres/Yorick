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

    self.tabBar.barTintColor = [YorickStyle color3];
    self.tabBarController.selectedViewController.navigationController.navigationBar.translucent = NO;
    self.tabBar.translucent = NO;
    
    // For Tab bar buttons
    
    UITabBarItem *tabBarItem0 = self.tabBar.items[0];
    UITabBarItem *tabBarItem1 = self.tabBar.items[1];
    UITabBarItem *tabBarItem2 = self.tabBar.items[2];
    
    
    [tabBarItem0 setImage: [[UIImage imageNamed:@"favorites-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setSelectedImage: [[UIImage imageNamed:@"favorites-selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setImage: [[UIImage imageNamed:@"browse-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage: [[UIImage imageNamed:@"browse-selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setImage: [[UIImage imageNamed:@"filters-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage: [[UIImage imageNamed:@"filters-selected"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    
    [tabBarItem0 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color2] }
                               forState:UIControlStateSelected];
    [tabBarItem1 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color2] }
                               forState:UIControlStateSelected];
    [tabBarItem2 setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color2] }
                               forState:UIControlStateSelected];

}

- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
    if ( item.badgeValue.intValue == appDelegate.manager.monologues.count ) {
        item.badgeValue = nil;
    }
    self.indexOfNewTab = [[theTabBar items] indexOfObject:item];
    if ( self.indexOfNewTab == self.selectedIndex ) {
        [self scrollToTop];
    }
}

-(void)scrollToTop {
    if (self.indexOfNewTab == 1) {
        NavigationController *nc = self.viewControllers[1];
        MonologuesListViewController *vc = nc.viewControllers[0];
        [vc.tableView setContentOffset:CGPointMake(0, 0 - vc.tableView.contentInset.top) animated:YES];
    }
}

// Called when screen is tapped on detail views.
- (void)hideTabBar {
    if (self.tabBar.hidden == false) {
        UITabBar *tabBar = self.tabBar;
        UIView *parent = tabBar.superview; // UILayoutContainerView
        
        CGRect tabFrame = tabBar.frame;
        tabFrame.origin.y += tabBar.frame.size.height;
        tabBar.frame = tabFrame;
        
        CGRect parentFrame = parent.frame;
        parentFrame.size.height += tabFrame.size.height;
        parent.frame = parentFrame;
        
        self.tabBar.hidden = true;
    }
}

- (void)showTabBar {
    if (self.tabBar.hidden == true) {
        UITabBar *tabBar = self.tabBar;
        UIView *parent = tabBar.superview; // UILayoutContainerView
        
        CGRect tabFrame = tabBar.frame;
        tabFrame.origin.y -= tabBar.frame.size.height;
        tabBar.frame = tabFrame;
        
        CGRect parentFrame = parent.frame;
        parentFrame.size.height -= tabFrame.size.height;
        parent.frame = parentFrame;
        
        self.tabBar.hidden = false;
    }

}

-(void)updateBrowseBadge {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Get Browse tab bar item
        NavigationController *nc = self.viewControllers[1];
        MonologuesListViewController *vc = nc.viewControllers[0];
        
        if (vc.manager == nil) {
            AppDelegate *appDelegate = (AppDelegate*)UIApplication.sharedApplication.delegate;
            vc.manager = appDelegate.manager;
        }
        
        UITabBarItem *tabBarItem1 = self.tabBar.items[1];
        tabBarItem1.badgeColor = [YorickStyle color2];
        int availableMonologuesCount = (int)[vc.manager filterMonologues:[vc.manager filterMonologuesForSettings:vc.manager.monologues] forSearchString:vc.searchController.searchBar.text].count;
        dispatch_async(dispatch_get_main_queue(), ^{
            tabBarItem1.badgeValue = [NSString stringWithFormat:@"%d",availableMonologuesCount];
            /* Remove monologue count badge
            if ( vc.manager.monologues.count == availableMonologuesCount ) {
                tabBarItem1.badgeValue = nil;
            }
            */
        });
    });
}

@end
