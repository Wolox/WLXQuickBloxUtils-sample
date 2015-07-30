//
//  PrivateDialogViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "PrivateDialogViewModel.h"
#import <DateTools.h>
#import <ObjectiveSugar.h>
#import "CollectionViewModel.h"
#import "NSString+CapitalizeFirstWord.h"

NSUInteger static MessagesAmountPerPage = 25;
NSString *const PrivateMessageReceivedNotification = @"privateMessageReceived";
NSString *const PrivateMessageNotSentNoticifation = @"privateMessageReceived";
NSString *const kPushAps = @"aps";
NSString *const kPushAlert = @"alert";
NSString *const kPushSound = @"sound";
NSString *const kPushSoundValue = @"default";

@interface PrivateDialogViewModel ()

@property (strong, nonatomic) QBChatDialog *dialog;
@property (strong, nonatomic) CollectionViewModel *collectionViewModel;
@property (strong, nonatomic) UserViewModel *userViewModel;
@property (strong, nonatomic) WLXQuickBloxUtils *quickbloxUtils;

@end

@implementation PrivateDialogViewModel

- (instancetype)initWithDialog:(QBChatDialog *)dialog quickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils userViewModel:(UserViewModel *)userViewModel {
    self = [super init];
    if(self) {
        _dialog = dialog;
        _senderId = quickbloxUtils.currentUser.ID;
        _title = userViewModel.email;
        _collectionViewModel = [[CollectionViewModel alloc] initWithAmountPerPage:MessagesAmountPerPage];
        _quickbloxUtils = quickbloxUtils;
        _userViewModel = userViewModel;
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - Message attribute methods

- (NSString *)lastMessage {
    return self.dialog.lastMessageText;
}

- (NSString *)lastMessageDate {
    return [self.dialog.lastMessageDate timeAgoSinceNow];
}

- (BOOL)isOutgoing:(MessageViewModel *)viewModel {
    return viewModel.senderId != self.userViewModel.qbId;
}

#pragma mark - Request methods

- (void)createMessage:(NSString *)message sentAt:(NSDate *)dateSent {
    __weak typeof(self) weakSelf = self;
    [self.quickbloxUtils sendMessageToDialog:self.dialog
                                        text:message
                               saveToHistory:YES
                                     success:^{
                                         __strong typeof(self) strongSelf = weakSelf;
                                         [strongSelf sendPush];
                                     } failure:nil];
    [self addMessage:message receivedAt:dateSent];
}

- (void)fetchMessages:(void (^)())success failure:(void(^)(NSString *))failure {
    __weak typeof(self) weakSelf = self;
    [self.quickbloxUtils messagesWithDialogID:self.dialog.ID
                                  queryParams:nil
                                         page:self.collectionViewModel.pageNumber
                                       amount:self.collectionViewModel.amountPerPage
                                      success:^(NSArray *messages) {
                                          __strong typeof(self) strongSelf = weakSelf;
                                          [strongSelf.collectionViewModel addPage:[self mapMessagesToViewModels:messages]];
                                          if(success) {
                                              success();
                                          }
                                      } failure:^(NSError *error) {
                                          if(failure) {
                                              failure([NSLocalizedString(@"message_fetching_error", nil) capitalizeFirstWord]);
                                          }
                                      }];
}

#pragma mark - Collection handling methods

- (MessageViewModel *)objectAtIndex:(NSUInteger)index {
    NSUInteger maxIndex = self.collectionViewModel.count - 1;
    return [self.collectionViewModel objectAtIndex:maxIndex - index];
}

- (void)resetData {
    [self.collectionViewModel reset];
}

- (NSUInteger)count {
    return self.collectionViewModel.count;
}

- (void)addMessage:(NSString *)message receivedAt:(NSDate *)date {
    QBChatMessage *newMessage = [QBChatMessage new];
    newMessage.text = message;
    newMessage.dateSent = date;
    [self.collectionViewModel addResource:[[MessageViewModel alloc] initWithQBChatMessage:newMessage] atIndex:0];
}

- (void)addMessage:(QBChatMessage *)message {
    [self.collectionViewModel addResource:[[MessageViewModel alloc] initWithQBChatMessage:message] atIndex:0];
}

#pragma mark - Notification methods

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:QBPrivateChatMessageReceivedNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:PrivateMessageReceivedNotification
                                                                                                          object:nil
                                                                                                        userInfo:@{@"message":notification.userInfo[@"message"]}];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:QBPrivateChatMessageCreationFailedNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      NSString *errorMSG = [NSLocalizedString(@"message_not_sent_error", nil) capitalizeFirstWord];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:PrivateMessageNotSentNoticifation
                                                                                                          object:nil
                                                                                                        userInfo:@{@"error":errorMSG}];
                                                  }];
}

#pragma mark - Private methods

- (NSArray *)mapMessagesToViewModels:(NSArray *)messages {
    return [messages map:^id(QBChatMessage *message) {
        return [[MessageViewModel alloc] initWithQBChatMessage:message];
    }];
}

- (void)sendPush {
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"@% sent you a message", nil), self.userViewModel.email];
    NSDictionary *dict = @{kPushAps:
                               @{kPushAlert:message,
                                 kPushSound:kPushSoundValue}};
    [self.quickbloxUtils sendPushWithDictionary:dict
                                     toUsersWithQbIds:@[@(self.userViewModel.qbId)]
                                              success:nil
                                              failure:nil];
}

@end
