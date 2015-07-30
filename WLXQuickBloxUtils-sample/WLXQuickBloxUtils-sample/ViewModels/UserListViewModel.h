//
//  UserListViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"
#import "UserViewModel.h"
#import "PrivateDialogViewModel.h"

@interface UserListViewModel : NSObject

@property (strong, nonatomic) NSString *title;

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils;

- (void)fetchUsers:(void (^)())success failure:(void(^)(NSString *))failure;
- (void)paginateIfNeeded:(NSUInteger)index success:(void (^)())success failure:(void(^)(NSString *))failure;
- (void)createDialogWithUser:(UserViewModel *)userViewModel success:(void(^)(PrivateDialogViewModel *))success failure:(void(^)(NSString *))failure;

- (UserViewModel *)objectAtIndex:(NSUInteger)index;
- (void)resetData;
- (NSUInteger)count;
- (void)addUser:(UserViewModel *)user;

@end
