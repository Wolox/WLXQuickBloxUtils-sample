//
//  ConversationListViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"
#import "PrivateDialogViewModel.h"

@interface ConversationListViewModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) PrivateDialogViewModel *selectedViewModel;

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils;

- (void)fetchDialogs:(void (^)())success failure:(void(^)(NSString *))failure;
- (void)paginateIfNeeded:(NSUInteger)index success:(void (^)())success failure:(void(^)(NSString *))failure;

- (PrivateDialogViewModel *)objectAtIndex:(NSUInteger)index;
- (void)resetData;
- (NSUInteger)count;

@end
