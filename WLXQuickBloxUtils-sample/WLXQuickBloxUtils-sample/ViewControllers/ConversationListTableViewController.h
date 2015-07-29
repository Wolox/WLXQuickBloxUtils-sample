//
//  ConversationListViewControllerTableViewController.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationListViewModel.h"
#import "TabBarItemViewControllerProtocol.h"

@interface ConversationListTableViewController : UITableViewController <TabBarItemViewControllerProtocol>

@property (strong, nonatomic) ConversationListViewModel *viewModel;

@end
