//
//  ConversationListViewControllerTableViewController.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "ConversationListTableViewController.h"
#import "ConversationViewController.h"

#import "PrivateDialogViewModel.h"

#import "ConversationTableViewCell.h"
#import "UITableViewController+RegisterNib.h"
#import "UIView+MakeToast.h"

NSString *const ConversationCellId = @"ConversationTableViewCell";
NSString *const GoToConversationSegueId = @"conversationSegue";
CGFloat const ConversationCellHeight = 70.0f;

@interface ConversationListTableViewController ()

@end

@implementation ConversationListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self registerNibWithIdentifier:ConversationCellId];
    [self initRefreshControl];
    [self performInitialRequest];
}

#pragma mark - <TabBatItemViewControllerProtocol>

- (void)setTabBarItemViewModel:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ConversationCellId forIndexPath:indexPath];
    
    PrivateDialogViewModel *privateDialogViewModel = [self.viewModel objectAtIndex:indexPath.row];
    
    [cell populateWithViewModel:privateDialogViewModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ConversationCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.selectedViewModel = [self.viewModel objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:GoToConversationSegueId sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [self.viewModel paginateIfNeeded:indexPath.row
                             success:^{
                                 __strong typeof(self) strongSelf = weakSelf;
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [strongSelf.tableView reloadData];
                                     [self.refreshControl endRefreshing];
                                 });
                             } failure:^(NSString *errorMSG) {
                                 __strong typeof(self) strongSelf = weakSelf;
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [strongSelf.view makeToastWithText:errorMSG];
                                 });
                             }];
}

#pragma mark - Request methods

- (void)performInitialRequest {
    __weak typeof(self) weakSelf = self;
    [self.viewModel fetchDialogs:^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadData];
            [strongSelf.refreshControl endRefreshing];
        });
    } failure:^(NSString *errorMSG) {
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.refreshControl endRefreshing];
            [strongSelf.view makeToastWithText:errorMSG];
        });
    }];
}

- (void)pullToRefresh {
    [self.viewModel resetData];
    [self performInitialRequest];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if([segueIdentifier isEqualToString:GoToConversationSegueId]) {
        ConversationViewController *viewController = [segue destinationViewController];
        viewController.viewModel = self.viewModel.selectedViewModel;
    }
}

#pragma mark - Initializers

- (void)initUI {
    self.navigationItem.title = self.viewModel.title;
}

- (void)initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
}

@end
