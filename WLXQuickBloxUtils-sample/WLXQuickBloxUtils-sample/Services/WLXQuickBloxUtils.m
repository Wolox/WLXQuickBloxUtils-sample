//
//  QuickbloxService.m
//  NightOwl
//
//  Created by Damian on 3/20/15.
//  Copyright (c) 2015 Damian. All rights reserved.
//

#import "WLXQuickBloxUtils.h"
#import "ObjectiveSugar.h"
#import <UIKit/UIKit.h>

#define BLOCKED_PRIVACY_LIST @"public"
#define kPushTypeKey @"type"

NSString *const QBGroupChatMessageReceivedNotification = @"groupChatMessageReceived";
NSString *const QBGroupChatMessageCreationFailedNotification = @"groupChatMessageCreationFailed";
NSString *const QBPrivateChatMessageReceivedNotification = @"privateChatMessageReceived";
NSString *const QBPrivateChatMessageCreationFailedNotification = @"privateChatMessageCreationFailed";

@interface WLXQuickBloxUtils ()

@property (strong, nonatomic) QBPrivacyList *blockedPrivacyList;
@property (nonatomic) BOOL retrievePrivacyListFailed;
@property (strong, nonatomic) NSDictionary *dialogTypeMapping;

@end

@implementation WLXQuickBloxUtils

- (instancetype)initWithAppId:(NSUInteger)appId registerKey:(NSString *)registerKey registerSecret:(NSString *)secret accountKey:(NSString *)accountKey {
    self = [super init];
    if(self) {
        [QBApplication sharedApplication].applicationId = appId;
        [QBConnection registerServiceKey:registerKey];
        [QBConnection registerServiceSecret:secret];
        [QBSettings setAccountKey:accountKey];
        [QBSettings setLogLevel:QBLogLevelDebug];
        [QBChat instance].autoReconnectEnabled = YES;
        [[QBChat instance] addDelegate:self];
        [QBChat instance].streamManagementEnabled = YES;
        self.dialogTypeMapping = @{@(DialogTypePrivate):@(QBChatDialogTypePrivate),
                                   @(DialogTypePublicGroup):@(QBChatDialogTypePublicGroup),
                                   @(DialogTypeGroup):@(DialogTypeGroup)};
    }
    return self;
}

- (QBChat *)chatInstance {
    return [QBChat instance];
}

- (void)setLogLevel:(QBLogLevel)logLevel {
    [QBSettings setLogLevel:logLevel];
}

#pragma mark - Authentication methods

- (void)logInWithAuthentication:(NSString *)authentication password:(NSString *)password delegate:(id<QBChatDelegate>)delegate success:(void(^)(QBUUser *))success failure:(void(^)(NSError *))failure {
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        [self quickbloxLogInWithAuthentication:authentication
                                      password:password
                                      delegate:delegate
                                       success:^(QBUUser *user) {
                                           success(user);
                                       } failure:^(NSError *error) {
                                           failure(error);
                                       }];
    } errorBlock:^(QBResponse *response) {
        if(failure) {
            failure(response.error.error);
        }
    }];
}

- (void)signUpWithAuthentication:(NSString *)authentication password:(NSString *)password delegate:(id<QBChatDelegate>)delegate success:(void(^)(QBUUser *))success failure:(void(^)(NSError *))failure {
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        QBUUser *user = [QBUUser user];
        user.login = authentication;
        user.password = password;
        
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            [self signUpInternalLoginWithAuthentication:authentication password:password delegate:delegate success:success failure:failure];
        } errorBlock:^(QBResponse *response) {
            if(response.status == QBResponseStatusCodeValidationFailed) {
                [self signUpInternalLoginWithAuthentication:authentication password:password delegate:delegate success:success failure:failure];
            }
        }];
    } errorBlock:^(QBResponse *response) {
        if(failure) {
            failure(response.error.error);
        }
    }];
}

- (void)logout {
    if([[QBChat instance] isLoggedIn]){
        [self unsubscribeForNotifications:^{
            [[QBChat instance] logout];
        } failure:^(NSError *error){
            [[QBChat instance] logout];
        }];
    } else {
        [[QBChat instance] logout];
    }
}

- (BOOL)isLoggedIn {
    return [self chatInstance].isLoggedIn;
}

- (BOOL)userIsLoggedIn {
    return [QBChat instance].currentUser != nil;
}

- (QBUUser *)currentUser {
    return [QBSession currentSession].currentUser;
}

#pragma mark - Dialog methods

- (void)createDialogWithOccupants:(NSArray *)occupants dialogType:(DialogType)type dialogName:(NSString *)name success:(void(^)(QBChatDialog *))success failure:(void(^)(NSError *))failure {
    QBChatDialog *chatDialog = [QBChatDialog new];
    chatDialog.type = [self.dialogTypeMapping[@(type)] intValue];
    chatDialog.occupantIDs = occupants;
    chatDialog.name = name;
    
    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
        if(success) {
            success(createdDialog);
        }
    } errorBlock:^(QBResponse *response) {
        if(failure) {
            failure(response.error.error);
        }
    }];
}

#pragma mark - Fetchers

- (void)messagesWithDialogID:(NSString *)dialogID queryParams:(NSDictionary *)parameters page:(NSUInteger)page amount:(NSUInteger)amount success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure {
    QBResponsePage *resPage = [QBResponsePage responsePageWithLimit:amount skip:page * amount];
    
    NSMutableDictionary *extendedParams = [NSMutableDictionary dictionaryWithDictionary:@{@"sort_desc": @"date_sent"}];
    [extendedParams addEntriesFromDictionary:parameters];
    
    [QBRequest messagesWithDialogID:dialogID
                    extendedRequest:extendedParams
                            forPage:resPage
                       successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *responsePage){
                           if(success) {
                               success(messages);
                           }
                       } errorBlock:^(QBResponse *response) {
                           if(failure) {
                               failure(response.error.error);
                           }
                       }];
}

- (void)dialogsWithQueryParams:(NSDictionary *)parameters page:(NSUInteger)page amount:(NSUInteger)amount success:(void(^)(NSArray *))success failure:(void(^)(NSError*))failure {
    NSMutableDictionary *extendedParams = [NSMutableDictionary dictionaryWithDictionary:@{@"sort_desc": @"last_message_date_sent"}];
    [extendedParams addEntriesFromDictionary:parameters];
    
    QBResponsePage *resPage = [QBResponsePage responsePageWithLimit:amount skip:page * amount];
    [QBRequest dialogsForPage:resPage extendedRequest:extendedParams successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
        if(success) {
            success(dialogObjects);
        }
    } errorBlock:^(QBResponse *response) {
        if(failure) {
            failure(response.error.error);
        }
    }];
}

- (void)retrieveAllUsersFromPage:(NSUInteger)page amount:(NSUInteger)amount queryParams:(NSDictionary *)parameters success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure {
    QBGeneralResponsePage *resPage = [QBGeneralResponsePage responsePageWithCurrentPage:page perPage:amount];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"id[ne]":@([QBSession currentSession].currentUser.ID)}];
    if(parameters) {
        [params addEntriesFromDictionary:parameters];
    }
    [QBRequest usersWithExtendedRequest:params
                                   page:resPage
                           successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                               if(success) {
                                   success(users);
                               }
                           } errorBlock:^(QBResponse *response) {
                               if(failure) {
                                   failure(response.error.error);
                               }
                           }];
}

- (void)usersWithIds:(NSArray *)userIds page:(NSUInteger)page amount:(NSUInteger)amount success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure {
    QBGeneralResponsePage *resPage = [QBGeneralResponsePage responsePageWithCurrentPage:page perPage:amount];
    [QBRequest usersWithIDs:userIds page:resPage
               successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                   if(success) {
                       success(users);
                   }
               } errorBlock:^(QBResponse *response) {
                   if(failure) {
                       failure(response.error.error);
                   }
               }];
}

#pragma mark - Update / Delete methods

- (void)removeOccupants:(NSArray *)occupantIds fromDialogWithId:(NSString *)dialogId success:(void(^)(QBChatDialog *))success failure:(void(^)(NSError *))failure {
    QBChatDialog *updateDialog = [[QBChatDialog alloc] initWithDialogID:dialogId];
    updateDialog.pullOccupantsIDs = occupantIds;
    
    [self updateDialog:updateDialog success:success failure:failure];
}

- (void)addOccupants:(NSArray *)occupantIds fromDialogWithId:(NSString *)dialogId success:(void(^)(QBChatDialog *))success failure:(void(^)(NSError *))failure {
    QBChatDialog *updateDialog = [[QBChatDialog alloc] initWithDialogID:dialogId];
    updateDialog.pushOccupantsIDs = occupantIds;
    
    [self updateDialog:updateDialog success:success failure:failure];
}

#pragma mark - Message methods

- (void)sendMessageToDialog:(QBChatDialog *)dialog text:(NSString *)text saveToHistory:(BOOL)saveToHistory success:(void(^)())success failure:(void(^)(NSError *))failure {
    QBChatMessage *message = [self messageWithText:text saveToHistory:saveToHistory];
    [dialog sendMessage:message sentBlock:^(NSError *error) {
        if(error) {
            if(failure) {
                failure(error);
            }
        } else {
            success();
        }
    }];
}

#pragma mark - Block User

- (void)blockUserWithId:(NSUInteger)qbId {
    [self changeUserPrivacyStatus:qbId allow:NO];
}

- (void)unblockUserWithId:(NSUInteger)qbId {
    [self changeUserPrivacyStatus:qbId allow:YES];
}

- (BOOL)userIsBlocked:(NSUInteger)qbId {
    if(!_blockedPrivacyList) {
        return NO;
    }
    
    id item = [_blockedPrivacyList.items detect:^BOOL(QBPrivacyItem *item) {
        return [item valueForType] == qbId && [item action] == DENY;
    }];
    return item != nil;
}

#pragma mark - <QBChatDelegate>

#pragma mark Private list delegate methods

- (void)chatDidReceivePrivacyList:(QBPrivacyList *)privacyList {
    _blockedPrivacyList = privacyList;
    [[QBChat instance] setPrivacyList:_blockedPrivacyList];
    NSLog(@"current privacy list: %@", privacyList);
}

- (void)chatDidNotReceivePrivacyListWithName:(NSString *)name error:(id)error {
    NSLog(@"chatDidNotReceivePrivacyListWithName: %@ due to error:%@", name, error);
}

- (void)chatDidLogin {
    [self setBlockedPrivacyList];
}

- (void)chatDidSetPrivacyListWithName:(NSString *)name {
    NSLog(@"chatDidSetPrivacyListWithName %@", name);
    [[QBChat instance] setDefaultPrivacyListWithName:name];
    [[QBChat instance] setActivePrivacyListWithName:name];
}

#pragma mark Group messages delegate methods

- (void)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID {
    [[NSNotificationCenter defaultCenter] postNotificationName:QBGroupChatMessageReceivedNotification
                                                        object:nil
                                                      userInfo:@{@"message":message}];
}

- (void)chatDidNotSendMessage:(QBChatMessage *)message toRoomJid:(NSString *)roomJid error:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:QBGroupChatMessageCreationFailedNotification
                                                        object:nil
                                                      userInfo:@{@"error":error}];
}

#pragma mark Private messages delegate methods

- (void)chatDidReceiveMessage:(QBChatMessage *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:QBPrivateChatMessageReceivedNotification
                                                        object:nil
                                                      userInfo:@{@"message":message}];
}

- (void)chatDidNotSendMessage:(QBChatMessage *)message error:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:QBPrivateChatMessageCreationFailedNotification
                                                        object:nil
                                                      userInfo:@{@"error":error}];
}

#pragma mark - Push methods

- (void)sendPushWithDictionary:(NSDictionary *)params toUsersWithQbIds:(NSArray *)qbIds success:(void(^)())success failure:(void(^)(NSError *))failure {
    QBMEvent *event = [QBMEvent event];
    event.notificationType = QBMNotificationTypePush;
    event.usersIDs = [qbIds join:@","];
    event.isDevelopmentEnvironment = ![QBApplication sharedApplication].productionEnvironmentForPushesEnabled;
    event.type = QBMEventTypeOneShot;
    
    NSError *error = nil;
    NSData *sendData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
    event.message = jsonString;
    
    [QBRequest createEvent:event successBlock:^(QBResponse *response, NSArray *events) {
        if(success) {
            success();
        }
    } errorBlock:^(QBResponse *response) {
        if(failure) {
            failure(response.error.error);
        }
    }];
}

#pragma mark - Private methods

- (void)quickbloxLogInWithAuthentication:(NSString *)authentication password:(NSString *)password delegate:(id<QBChatDelegate>)delegate success:(void (^)(QBUUser *))success failure:(void (^)(NSError *))failure {
    [QBRequest logInWithUserLogin:authentication password:password successBlock:^(QBResponse *response, QBUUser *user) {
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = [user ID];
        currentUser.password = password;
        
        [[QBChat instance] addDelegate:delegate];
        [[QBChat instance] loginWithUser:currentUser];
        [self subscribeForNotificationsWithDeviceToken:self.deviceToken];
        if(success) {
            success(currentUser);
        }
    } errorBlock:^(QBResponse *response) {
        if(failure) {
            failure(response.error.error);
        }
    }];
}

- (void)changeUserPrivacyStatus:(NSUInteger)qbId allow:(BOOL)allow {
    QBPrivacyItemAction action = allow ? ALLOW : DENY;
    
    if (_blockedPrivacyList) {
        QBPrivacyItem *item = [_blockedPrivacyList.items detect:^BOOL(QBPrivacyItem *item) {
            return item.valueForType == qbId;
        }];
        if(item) {
            [_blockedPrivacyList.items removeObject:item];
        }
        item = [[QBPrivacyItem alloc] initWithType:USER_ID valueForType:qbId action:action];
        [_blockedPrivacyList addObject:item];
    } else {
        QBPrivacyItem *item = [[QBPrivacyItem alloc] initWithType:USER_ID valueForType:qbId action:action];
        _blockedPrivacyList = [[QBPrivacyList alloc] initWithName:BLOCKED_PRIVACY_LIST items:@[item]];
    }
    
    [[QBChat instance] setPrivacyList:_blockedPrivacyList];
}

- (void)setBlockedPrivacyList {
    [[QBChat instance] retrievePrivacyListWithName:BLOCKED_PRIVACY_LIST];
}

- (void)subscribeForNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [QBRequest registerSubscriptionForDeviceToken:deviceToken uniqueDeviceIdentifier:UUIDString
                                     successBlock:^(QBResponse *response, NSArray *subscriptions) {
                                         NSLog(@"success");
                                     } errorBlock:^(QBError *error) {
                                         NSLog(@"Response error:%@", error);
                                     }];
}

- (void)unsubscribeForNotifications:(void(^)())success failure:(void(^)(NSError *))failure {
    NSString * UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [QBRequest unregisterSubscriptionForUniqueDeviceIdentifier:UUIDString
                                                  successBlock:^(QBResponse *response) {
                                                      if(success) {
                                                          success();
                                                      }
                                                  } errorBlock:^(QBError *error) {
                                                      if(failure) {
                                                          failure(error.error);
                                                      }
                                                  }];
}

- (void)sendPushWithText:(NSString *)text qbIds:(NSArray *)qbIds success:(void(^)())success failure:(void(^)(NSError *))failure {
    NSString *stringIds = [qbIds join:@","];
    
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    NSMutableDictionary *aps = [NSMutableDictionary dictionary];
    [aps setObject:@"default" forKey:QBMPushMessageSoundKey];
    [aps setObject:text forKey:QBMPushMessageAlertKey];
    [aps setObject:QBPush forKey:kPushTypeKey];
    [payload setObject:aps forKey:QBMPushMessageApsKey];
    
    QBMPushMessage *pushMessage = [[QBMPushMessage alloc] initWithPayload:payload];
    
    [QBRequest sendPush:pushMessage toUsers:stringIds successBlock:^(QBResponse *response, QBMEvent *event) {
        if(success) {
            success();
        }
    } errorBlock:^(QBError *error) {
        if(failure) {
            failure(error.error);
        }
    }];
}

- (QBChatMessage *)messageWithText:(NSString *)text saveToHistory:(BOOL)save {
    QBChatMessage *message = [QBChatMessage message];
    [message setText:text];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"save_to_history": @(save)}];
    [message setCustomParameters:params];
    return message;
}

- (void)signUpInternalLoginWithAuthentication:(NSString *)authentication password:(NSString *)password delegate:(id<QBChatDelegate>)delegate success:(void(^)(QBUUser *))success failure:(void(^)(NSError *))failure {
    [self quickbloxLogInWithAuthentication:authentication password:password delegate:delegate success:^(QBUUser *user){
        if(success) {
            success(user);
        }
    } failure:^(NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}

- (void)updateDialog:(QBChatDialog *)dialog success:(void(^)(QBChatDialog *))success failure:(void(^)(NSError *))failure {
    [QBRequest updateDialog:dialog successBlock:^(QBResponse *responce, QBChatDialog *dialog) {
        if(success) {
            success(dialog);
        }
    } errorBlock:^(QBResponse *response) {
        if(failure) {
            failure(response.error.error);
        }
    }];
}

@end
