//
//  UserListViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "UserListViewModel.h"
#import "CollectionViewModel.h"
#import "NSString+CapitalizeFirstWord.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@interface UserListViewModel ()

@property (strong, nonatomic) WLXQuickBloxUtils *quickbloxUtils;
@property (strong, nonatomic) CollectionViewModel *collectionViewModel;

@end

@implementation UserListViewModel

NSUInteger const UserAmountPerPage = 25;
NSUInteger const UserListItemsBeforePagination = 5;

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils {
    self = [super init];
    if(self) {
        _title = [NSLocalizedString(@"user_list_title", nil) uppercaseString];
        _quickbloxUtils = quickbloxUtils;
        _collectionViewModel = [[CollectionViewModel alloc] initWithAmountPerPage:UserAmountPerPage];
    }
    return self;
}

#pragma mark - Request methods

- (void)fetchUsers:(void (^)())success failure:(void(^)(NSString *))failure {
    __weak typeof(self) weakSelf = self;
    [self.quickbloxUtils retrieveAllUsersFromPage:self.collectionViewModel.pageNumber
                                           amount:self.collectionViewModel.amountPerPage
                                      queryParams:nil
                                          success:^(NSArray *resources) {
                                              __strong typeof(self) strongSelf = weakSelf;
                                              [strongSelf.collectionViewModel addPage:[self mapUsersToViewModels:resources]];
                                              if(success) {
                                                  success();
                                              }
                                          } failure:^(NSError *error) {
                                              if(failure) {
                                                  failure([NSLocalizedString(@"user_fetching_error", nil) capitalizeFirstWord]);
                                              }
                                          }];
}

- (void)paginateIfNeeded:(NSUInteger)index success:(void (^)())success failure:(void(^)(NSString *))failure {
    // paginates when there are more pages and 5 items are left to get to the last item of the page
    if(!self.collectionViewModel.isLastPage && [self.collectionViewModel isEndOfPage:(index + UserListItemsBeforePagination)]) {
        [self fetchUsers:success failure:failure];
    }
}


- (void)createDialogWithUser:(UserViewModel *)userViewModel success:(void(^)(PrivateDialogViewModel *))success failure:(void(^)(NSString *))failure {
    __weak typeof(self) weakSelf = self;
    NSArray *occupants = @[@(userViewModel.qbId)];
    [self.quickbloxUtils createDialogWithOccupants:occupants
                                        dialogType:DialogTypePrivate
                                        dialogName:nil
                                           success:^(QBChatDialog *dialog) {
                                               __strong typeof(self) strongSelf = weakSelf;
                                               PrivateDialogViewModel *dialogViewModel = [strongSelf dialogToViewModel:dialog user:userViewModel];
                                               if(success) {
                                                   success(dialogViewModel);
                                               }
                                           } failure:^(NSError *error) {
                                               if(failure) {
                                                   NSString *errorMSG = [NSLocalizedString(@"create_dialog_error", nil) capitalizeFirstWord];
                                                   failure(errorMSG);
                                               }
                                           }];
}

#pragma mark - Mapping methods

- (NSArray *)mapUsersToViewModels:(NSArray *)users {
    return [users map:^id(QBUUser *user) {
        return [[UserViewModel alloc] initWithQBUUser:user];
    }];
}

- (PrivateDialogViewModel *)dialogToViewModel:(QBChatDialog *)dialog user:(UserViewModel *)userViewModel{
    return [[PrivateDialogViewModel alloc] initWithDialog:dialog quickbloxUtils:self.quickbloxUtils userViewModel:userViewModel];
}

#pragma mark - Collection handling methods

- (UserViewModel *)objectAtIndex:(NSUInteger)index {
    return [self.collectionViewModel objectAtIndex:index];
}

- (void)resetData {
    [self.collectionViewModel reset];
}

- (NSUInteger)count {
    return self.collectionViewModel.count;
}

- (void)addUser:(UserViewModel *)user {
    [self.collectionViewModel addResource:user];
}

@end
