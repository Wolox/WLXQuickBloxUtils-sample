//
//  PrivateDialogViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"
#import "MessageViewModel.h"
#import "UserViewModel.h"

extern NSString *const PrivateMessageReceivedNotification;
extern NSString *const PrivateMessageNotSentNoticifation;

@interface PrivateDialogViewModel : NSObject

@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSUInteger senderId;

- (instancetype)initWithDialog:(QBChatDialog *)dialog quickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils userViewModel:(UserViewModel *)userViewModel ;

- (NSString *)lastMessage;
- (NSString *)lastMessageDate;
- (BOOL)isOutgoing:(MessageViewModel *)viewModel;

- (MessageViewModel *)objectAtIndex:(NSUInteger)index;
- (void)resetData;
- (NSUInteger)count;
- (void)addMessage:(NSString *)message receivedAt:(NSDate *)date;
- (void)addMessage:(QBChatMessage *)message;

- (void)createMessage:(NSString *)message sentAt:(NSDate *)dateSent;
- (void)fetchMessages:(void (^)())success failure:(void(^)(NSString *))failure;

@end
