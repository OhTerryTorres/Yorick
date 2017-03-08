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
    NSArray *unselectedImageNames = [[NSArray alloc] initWithObjects:
                                     @"favorites-unselected", @"browse-unselected", @"filters-unselected", nil];
    NSArray *selectedImageNames = [[NSArray alloc] initWithObjects:
                                   @"favorites-selected", @"browse-selected", @"filters-selected", nil];
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *tabBarItem = self.tabBar.items[i];
        [tabBarItem setImage: [[UIImage imageNamed:unselectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem setSelectedImage: [[UIImage imageNamed:selectedImageNames[i]] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [YorickStyle color2] }
                                   forState:UIControlStateSelected];
    }
    UITabBarItem *tabBarItem1 = self.tabBar.items[1];
    tabBarItem1.badgeColor = [YorickStyle color2];

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
        int availableMonologuesCount = (int)[vc.manager filterMonologues:[vc.manager filterMonologuesForSettings:vc.manager.monologues] forSearchString:vc.searchController.searchBar.text].count;
        dispatch_async(dispatch_get_main_queue(), ^{
            tabBarItem1.badgeValue = [NSString stringWithFormat:@"%d",availableMonologuesCount];
            // Remove monologue count badge
            if ( vc.manager.monologues.count == availableMonologuesCount ) {
                tabBarItem1.badgeValue = nil;
            }
        });
    });
}

@end
