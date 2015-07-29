//
//  ConversationListViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "ConversationListViewModel.h"
#import "CollectionViewModel.h"
#import "NSString+CapitalizeFirstWord.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

NSUInteger const ConversationAmountPerPage = 25;
NSUInteger const ConversationListItemsBeforePagination = 5;

@interface ConversationListViewModel ()

@property (strong, nonatomic) WLXQuickBloxUtils *quickbloxUtils;
@property (strong, nonatomic) CollectionViewModel *collectionViewModel;

@end

@implementation ConversationListViewModel

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils {
    self = [super init];
    if(self) {
        _title = [NSLocalizedString(@"conversation_list_title", nil) uppercaseString];
        _quickbloxUtils = quickbloxUtils;
        _collectionViewModel = [[CollectionViewModel alloc] initWithAmountPerPage:ConversationAmountPerPage];
    }
    return self;
}

#pragma mark - Request methods

- (void)fetchDialogs:(void (^)())success failure:(void(^)(NSString *))failure {
    __weak typeof(self) weakSelf = self;
    [self.quickbloxUtils dialogsWithQueryParams:@{ @"type": @(DialogTypePrivate) }
                                           page:self.collectionViewModel.pageNumber
                                         amount:self.collectionViewModel.amountPerPage
                                        success:^(NSArray *dialogs) {
                                            __strong typeof(self) strongSelf = weakSelf;
                                            [strongSelf fetchUsersWithIds:[strongSelf otherUserIdsFromDialogs:dialogs]
                                                                  success:^(NSArray *userViewModels){
                                                                      [strongSelf.collectionViewModel addPage:[self mapConversationsToViewModels:dialogs
                                                                                                                                           users:userViewModels]];
                                                                      if(success) {
                                                                          success();
                                                                      }
                                                                  } failure:^(NSString *errorMSG) {
                                                                      if(failure) {
                                                                          failure(errorMSG);
                                                                      }
                                                                  }];
                                        } failure:^(NSError *error) {
                                            if(failure) {
                                                failure([NSLocalizedString(@"conversation_fetching_error", nil) capitalizeFirstWord]);
                                            }
                                        }];
}

- (void)fetchUsersWithIds:(NSArray *)userIds success:(void (^)(NSArray *))success failure:(void(^)(NSString *))failure {
    __weak typeof(self) weakSelf = self;
    [self.quickbloxUtils usersWithIds:userIds
                                 page:0
                               amount:self.collectionViewModel.amountPerPage
                              success:^(NSArray *users) {
                                  __strong typeof(self) strongSelf = weakSelf;
                                  if(success) {
                                      success([strongSelf mapUsersToViewModels:users]);
                                  }
                              } failure:^(NSError *error) {
                                  if(failure) {
                                      failure([NSLocalizedString(@"user_fetching_error", nil) capitalizeFirstWord]);
                                  }
                              }];
}

- (void)paginateIfNeeded:(NSUInteger)index success:(void (^)())success failure:(void(^)(NSString *))failure {
    // paginates when there are more pages and 5 items are left to get to the last item of the page
    if(!self.collectionViewModel.isLastPage && [self.collectionViewModel isEndOfPage:(index + ConversationListItemsBeforePagination)]) {
        [self fetchDialogs:success failure:failure];
    }
}

#pragma mark - Mapping methods

- (NSArray *)mapConversationsToViewModels:(NSArray *)conversations users:(NSArray *)userViewModels {
    __weak typeof(self) weakSelf = self;
    return [conversations map:^id(QBChatDialog *dialog) {
        __strong typeof(self) strongSelf = weakSelf;
        UserViewModel *userViewModel = [userViewModels detect:^BOOL(UserViewModel *user) {
            return [dialog.occupantIDs includes:@(user.qbId)];
        }];
        return [[PrivateDialogViewModel alloc] initWithDialog:dialog quickbloxUtils:strongSelf.quickbloxUtils userViewModel:userViewModel];
    }];
}

- (NSArray *)mapUsersToViewModels:(NSArray *)users {
    return [users map:^id(QBUUser *user) {
        return [[UserViewModel alloc] initWithQBUUser:user];
    }];
}

- (NSArray *)otherUserIdsFromDialogs:(NSArray *)dialogs {
    __weak typeof(self) weakSelf = self;
    return [dialogs map:^id(QBChatDialog *dialog) {
        return [dialog.occupantIDs detect:^BOOL(NSNumber *occupantId) {
            __strong typeof(self) strongSelf = weakSelf;
            return [occupantId integerValue] != strongSelf.quickbloxUtils.currentUser.ID;
        }];
    }];
}

#pragma mark - Collection handling methods

- (PrivateDialogViewModel *)objectAtIndex:(NSUInteger)index {
    return [self.collectionViewModel objectAtIndex:index];
}

- (void)resetData {
    [self.collectionViewModel reset];
}

- (NSUInteger)count {
    return self.collectionViewModel.count;
}

@end
