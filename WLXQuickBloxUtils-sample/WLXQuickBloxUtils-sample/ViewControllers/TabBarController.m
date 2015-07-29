//
//  TabBarController.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "TabBarController.h"
#import <ObjectiveSugar.h>
#import "UserListTableViewController.h"
#import "UINavigationController+RootViewController.h"
#import "TabBarItemViewControllerProtocol.h"

@implementation TabBarController

#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBarItemsAndViewControllers];
}

#pragma mark Initializers

- (void)initTabBarItemsAndViewControllers {
    [self.viewControllers eachWithIndex:^(UINavigationController *navigationController, NSUInteger index) {
        id<TabBarItemViewControllerProtocol> viewController = [navigationController rootViewController];
        [viewController setTabBarItemViewModel:[self.viewModel tabBarItemViewModelAtIndex:index]];
        
        UITabBarItem *item = [self.tabBar.items objectAtIndex:index];
        item.title = [self.viewModel tabBarItemTitleAtIndex:index];
    }];
}

@end
