//
//  UserListTableViewController.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "UserListTableViewController.h"
#import "UserTableViewCell.h"
#import "UITableViewController+RegisterNib.h"
#import "UIView+MakeToast.h"
#import "UserTableViewCellDelegate.h"
#import "ConversationViewController.h"
#import "BackButtonItem.h"

NSString *const UserCellId = @"UserTableViewCell";
NSString *const StartConversationSegueId = @"startConversationSegue";

@interface UserListTableViewController ()<UserTableViewCellDelegate>

@property (strong, nonatomic) PrivateDialogViewModel *conversationViewModel;

@end

@implementation UserListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self registerNibWithIdentifier:UserCellId];
    [self initRefreshControl];
    [self performInitialRequest];
}

#pragma mark - <SetViewModelProtocol>

- (void)setTabBarItemViewModel:(id)viewModel {
    _viewModel = viewModel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellId forIndexPath:indexPath];
    
    UserViewModel *userViewModel = [self.viewModel objectAtIndex:indexPath.row];
    
    [cell populateWithViewModel:userViewModel delegate:self indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [self.viewModel paginateIfNeeded:indexPath.row
                             success:^{
                                 __strong typeof(self) strongSelf = weakSelf;
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [strongSelf.tableView reloadData];
                                 });
                             } failure:^(NSString *errorMSG) {
                                 __strong typeof(self) strongSelf = weakSelf;
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [strongSelf.view makeToastWithText:errorMSG];
                                 });
                             }];
}

#pragma mark - <UserTableViewCellDelegate>

- (void)didPressTalk:(UIButton *)sender {
    UserViewModel *targetUserViewModel = [self.viewModel objectAtIndex:sender.tag];
    [self.viewModel createDialogWithUser:targetUserViewModel
                                 success:^(PrivateDialogViewModel *dialogViewModel) {
                                     self.conversationViewModel = dialogViewModel;
                                     [self performSegueWithIdentifier:StartConversationSegueId sender:self];
                                 } failure:^(NSString *errorMSG) {
                                     [self.view makeToastWithText:errorMSG];
                                 }];
}

#pragma mark - Request methods

- (void)performInitialRequest {
    __weak typeof(self) weakSelf = self;
    [self.viewModel fetchUsers:^{
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = [segue identifier];
    if([segueIdentifier isEqualToString:StartConversationSegueId]) {
        ConversationViewController *viewController = [segue destinationViewController];
        viewController.viewModel = self.conversationViewModel;
        self.conversationViewModel = nil;
    }
}

- (void)pullToRefresh {
    [self.viewModel resetData];
    [self performInitialRequest];
}

#pragma mark - Initializers

- (void)initRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)initUI {
    self.navigationItem.title = self.viewModel.title;
    self.navigationItem.backBarButtonItem = [BackButtonItem new];
}

@end
