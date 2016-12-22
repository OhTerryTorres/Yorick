//
//  TabBarController.m
//  monologues
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

    UIColor *color1 = [UIColor colorWithRed:36.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1];
    // a lower alpha can help the color match the navigation bar
    UIColor *color2 = [UIColor colorWithRed:141.0/255.0 green:171.0/255.0 blue:175.0/255.0 alpha:1];
    // Gray Font to match gray icon
    UIColor *color3 = [UIColor colorWithRed:100.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1];
    
    self.tabBar.barTintColor = color2;
    self.tabBarController.selectedViewController.navigationController.navigationBar.translucent = NO;
    self.tabBar.translucent = NO;
    
    // For Tab bar buttons
    self.tabBar.tintColor = color1;

    
    // ****
    //
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    
    UIImage *unselectedImage = [UIImage imageNamed:@"barbuttonunselected"];
    UIImage *selectedImage = [UIImage imageNamed:@"barbuttonselected"];
    
    [tabBarItem0 setImage: [[UIImage imageNamed:@"favorites-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setSelectedImage: [UIImage imageNamed:@"favorites-selected"]];
    [tabBarItem1 setImage: [[UIImage imageNamed:@"browse-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage: [UIImage imageNamed:@"browse-selected"]];
    [tabBarItem2 setImage: [[UIImage imageNamed:@"filters-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage: [UIImage imageNamed:@"filters-selected"]];
    
    [tabBarItem0 setTitleTextAttributes:@{ NSForegroundColorAttributeName : color3 }
                               forState:UIControlStateNormal];
    [tabBarItem0 setTitleTextAttributes:@{ NSForegroundColorAttributeName : color1 }
                               forState:UIControlStateSelected];
    [tabBarItem1 setTitleTextAttributes:@{ NSForegroundColorAttributeName : color3 }
                               forState:UIControlStateNormal];
    [tabBarItem1 setTitleTextAttributes:@{ NSForegroundColorAttributeName : color1 }
                               forState:UIControlStateSelected];
    [tabBarItem2 setTitleTextAttributes:@{ NSForegroundColorAttributeName : color3 }
                               forState:UIControlStateNormal];
    [tabBarItem2 setTitleTextAttributes:@{ NSForegroundColorAttributeName : color1 }
                               forState:UIControlStateSelected];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    self.indexOfNewTab = [[theTabBar items] indexOfObject:item];
}

- (void)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ( self.indexOfNewTab != tabBarController.selectedIndex ) {
        /*
        self.tabBarController.selectedViewController.navigationController.navigationBar.translucent = NO;
        viewController.tabBarController.tabBar.translucent = NO;
        viewController.navigationController.navigationBar.translucent = NO;
        
        // Disable interaction during animation to avoids bugs.
        self.tabBarController.view.userInteractionEnabled = NO;
    
        // Get the views.
        UIView * fromView = tabBarController.selectedViewController.view;
        UIView * toView = [[tabBarController.viewControllers objectAtIndex:self.indexOfNewTab] view];
        
        // Get the size of the view area.
        CGRect viewSize = fromView.frame;
        BOOL scrollRight = self.indexOfNewTab > tabBarController.selectedIndex;
        NSLog(@"index of fromView is %d",tabBarController.selectedIndex);
        NSLog(@"index of toView is %d",self.indexOfNewTab);
    
        // Add the to view to the tab bar view.
        [fromView.superview addSubview:toView];
        [fromView.superview addSubview:fromView];
    
        // Position it off screen.
        toView.frame = CGRectMake((scrollRight ? (viewSize.size.width) : -(viewSize.size.width)), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
    
        [UIView animateWithDuration:0.25
                     animations: ^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         fromView.frame = CGRectMake(( scrollRight ? -(viewSize.size.width) : (viewSize.size.width) ), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                         toView.frame = CGRectMake((viewSize.origin.x), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                                                      // Remove the old view from the tabbar view.
                                                      [fromView removeFromSuperview];
                                                      
                                                      // Restore interaction.
                                                      self.tabBarController.view.userInteractionEnabled = YES;
                
                         }
                     }];
    
    // When the current tab is tapped, scroll to the top.
         */
    } else [self scrollToTop];

}


-(void)scrollToTop {
    if (self.indexOfNewTab == 0) {
        NavigationController *nc = [self.viewControllers objectAtIndex:0];
        BrowseViewController *vc = [nc.viewControllers objectAtIndex:0];
        [vc.tableView setContentOffset:CGPointMake(0, 0 - vc.tableView.contentInset.top) animated:YES];
    } else if (self.indexOfNewTab == 1) {
        NavigationController *nc = [self.viewControllers objectAtIndex:1];
        FavoritesViewController *vc = [nc.viewControllers objectAtIndex:0];
        [vc.tableView setContentOffset:CGPointMake(0, 0 - vc.tableView.contentInset.top) animated:YES];
    } /*else if (self.indexOfNewTab == 2) {
        FiltersViewController *vc = [self.viewControllers objectAtIndex:2];
        [vc.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }*/
}

@end
