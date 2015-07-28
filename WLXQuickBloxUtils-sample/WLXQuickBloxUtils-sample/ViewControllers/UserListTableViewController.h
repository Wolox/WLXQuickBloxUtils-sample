//
//  UserListTableViewController.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListViewModel.h"
#import "TabBarItemViewControllerProtocol.h"

@interface UserListTableViewController : UITableViewController <TabBarItemViewControllerProtocol>

@property (strong, nonatomic) UserListViewModel *viewModel;

@end
