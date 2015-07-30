//
//  QuickbloxService.h
//  NightOwl
//
//  Created by Damian on 3/20/15.
//  Copyright (c) 2015 Damian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

#define kQBRingThickness = 1.f;
#define kQBAnswerTimeInterval = 60.f;
#define kQBRTCDisconnectTimeInterval = 60.f;

#define QB_DEFAULT_ICE_SERVERS 0

#define QBPush @"QBPush"

extern NSString *const QBGroupChatMessageReceivedNotification;
extern NSString *const QBGroupChatMessageCreationFailedNotification;
extern NSString *const QBPrivateChatMessageReceivedNotification;
extern NSString *const QBPrivateChatMessageCreationFailedNotification;

typedef enum {
    DialogTypePublicGroup = 1,
    DialogTypeGroup = 2,
    DialogTypePrivate = 3
}DialogType;

@interface WLXQuickBloxUtils : NSObject <QBChatDelegate>

// Device token. Must be set in AppDelegate's 'application:didRegisterForRemoteNotificationsWithDeviceToken:' method
@property (strong, nonatomic) NSData *deviceToken;

- (instancetype)initWithAppId:(NSUInteger)appId registerKey:(NSString *)registerKey registerSecret:(NSString *)secret accountKey:(NSString *)accountKey;

/**
 Returns current chat singleton instance.
 
 @return QBChat singleton
 */
- (QBChat *)chatInstance;


/**
 Sets the log level. Default level is Debug.
 
 @param logLevel The log level to be set.
 */
- (void)setLogLevel:(QBLogLevel)logLevel;

/**
 Performs log in into QuickBlox.
 
 @warning Do not call this method after a sign in.
 
 @param authentication The user's username.
 @param password The user's password.
 @param delegate A delegate to listen to chat changes.
 @param success A block object to be executed when the log in finishes successfully. This block has no return value and takes one argument: a QBUUser
 @param failure A block object to be executed when the log in fails. This block has no return value and takes one argument: a NSError.
 */

- (void)logInWithAuthentication:(NSString *)authentication
                       password:(NSString *)password
                       delegate:(id<QBChatDelegate>)delegate
                        success:(void(^)(QBUUser *))success
                        failure:(void(^)(NSError *))failure;

/**
 Performs sign in into QuickBlox.
 
 @param authentication The user's username.
 @param password The user's password.
 @param delegate A delegate to listen to chat changes.
 @param success A block object to be executed when the sign in finishes successfully. This block has no return value and takes one argument: a QBUUser
 @param failure A block object to be executed when the sign in fails. This block has no return value and takes one argument: a NSError.
 */

- (void)signUpWithAuthentication:(NSString *)authentication
                        password:(NSString *)password
                        delegate:(id<QBChatDelegate>)delegate
                         success:(void(^)(QBUUser *))success
                         failure:(void(^)(NSError *))failure;
/**
 Logs out from QuickBlox.
 
 @warning If user is not logged in, this method does nothing.
 */
- (void)logout;

/**
 Returns a boolean for the user's authentication state
 */
- (BOOL)isLoggedIn;

/**
 Creates a new private dialog. If private dialog exists, it returns that dialog.
 
 @param occupants The dialog's occupants IDs.
 @param type The dialog type, represented by the enum type DialogType
 @param type The dialog name
 @param success A block object to be executed after the dialog is successfully created. This block has no return value and takes one argument: a QBChatDialog.
 @param failure A block object to be executed when the creation of the dialog fails. This block has no return value and takes one argument: a NSError.
 */

- (void)createDialogWithOccupants:(NSArray *)occupants
                       dialogType:(DialogType)type
                       dialogName:(NSString *)name
                          success:(void(^)(QBChatDialog *))success
                          failure:(void(^)(NSError *))failure;


/**
 Fetches messages belonging to a certain dialog
 
 @param dialogID The dialog's ID.
 @param queryParams Extra parameters. Can be nil. Parameters should be formatted as QuickBlox documentation indicates.
 @param page The requested page's number.
 @param amount The maximum amount of records to fetch.
 @param success A block object to be executed when the request finishes successfully. This block has no return value and takes one argument: a NSArray
 @param failure A block object to be executed when the request fails. This block has no return value and takes one argument: a NSError.
 */
- (void)messagesWithDialogID:(NSString *)dialogID
                 queryParams:(NSDictionary *)parameters
                        page:(NSUInteger)page
                      amount:(NSUInteger)amount
                     success:(void(^)(NSArray *))success
                     failure:(void(^)(NSError *))failure;

/**
 Fetches user's dialogs
 
 @param queryParams Extra parameters. Can be nil. Parameters should be formatted as QuickBlox documentation indicates.
 @param page The requested page's number.
 @param amount The maximum amount of records to fetch.
 @param success A block object to be executed when the request finishes successfully. This block has no return value and takes one argument: a NSArray
 @param failure A block object to be executed when the request fails. This block has no return value and takes one argument: a NSError.
 */
- (void)dialogsWithQueryParams:(NSDictionary *)parameters
                          page:(NSUInteger)page
                        amount:(NSUInteger)amount
                       success:(void(^)(NSArray *))success
                       failure:(void(^)(NSError*))failure;

/**
 Fetches all users from Quickblox application
 
 @param page The requested page's number.
 @param amount The maximum amount of records to fetch.
 @param queryParams Extra parameters. Can be nil. Parameters should be formatted as QuickBlox documentation indicates.
 @param success A block object to be executed when the request finishes successfully. This block has no return value and takes one argument: a NSArray
 @param failure A block object to be executed when the request fails. This block has no return value and takes one argument: a NSError.
 */
- (void)retrieveAllUsersFromPage:(NSUInteger)page
                          amount:(NSUInteger)amount
                   queryParams:(NSDictionary *)parameters
                         success:(void(^)(NSArray *))success
                         failure:(void(^)(NSError *))failure;

/**
 Fetches users with ids
 
 @param userIds The user's ids to fetch.
 @param page The requested page's number.
 @param amount The maximum amount of records to fetch.
 @param success A block object to be executed when the request finishes successfully. This block has no return value and takes one argument: a NSArray
 @param failure A block object to be executed when the request fails. This block has no return value and takes one argument: a NSError.
 */
- (void)usersWithIds:(NSArray *)userIds
                page:(NSUInteger)page
              amount:(NSUInteger)amount
             success:(void(^)(NSArray *))success
             failure:(void(^)(NSError *))failure;

/**
 Sends message to a chat
 
 @warning QBGroupChatMessageReceivedNotification or QBPrivateChatMessageReceivedNotification notification is fired when the message was
            successfully received.
            It sends the QBChatMessage in the userInfo dictionary.
 
          QBGroupChatMessageCreationFailed or QBPrivateChatMessageCreationFailed notification is fired when the message could not be sent.
            It sends an NSError in the userInfo dictionary.

 @param text The message text to send.
 @param saveToHistory A boolean indicating if message should be saved in the dialog's history.
 @param success A block object to be executed when the message was successfully sent. It has no return value.
 @param failure A block object to be executed when the request fails. This block has no return value and takes one argument: a NSError.
*/
- (void)sendMessageToDialog:(QBChatDialog *)dialog
                       text:(NSString *)text
              saveToHistory:(BOOL)saveToHistory
                    success:(void(^)())success
                    failure:(void(^)(NSError *))failure;

/**
 Blocks a user with given quickblox id.
 
 @warning if privacy list does not exist, it creates it
 
 @param qbId The user's quickblox ID of the user to be blocked.
 
 */
- (void)blockUserWithId:(NSUInteger)qbId;

/**
 Unblocks a user with given quickblox id.
 
 @warning if privacy list does not exist, it creates it
 
 @param qbId The user's quickblox ID of the user to be blocked.
 
 */
- (void)unblockUserWithId:(NSUInteger)qbId;

/**
 Returns if the user is blocked or not by current user.
 
 @param qbId The target user's quickblox ID.
 
 @return YES if the user was blocked by current user, NO otherwise.
 */
- (BOOL)userIsBlocked:(NSUInteger)qbId;


/**
 Returns if the user is logged in.
 
 @return YES if the user is logged in, NO otherwise.
 */
- (BOOL)userIsLoggedIn;


/**
 Returns the current logged user
 
 @return QBUUser representing the logged user.
 */
- (QBUUser *)currentUser;


/**
 Subscribes user for receiving remote notifications.
 
 @warning should be called by application didRegisterForRemoteNotificationsWithDeviceToken.
 
 @param deviceToken The phone's device token.
 */
- (void)subscribeForNotificationsWithDeviceToken:(NSData *)deviceToken;


/**
 Unsubscribe user from receiving remote notifications.
 
 @warning should be called before logging out. Is called in logout method automatically.
 
 @param success A block object to be executed if the request is successfull. It takes no argument and has no return value.
 @param failure A block object to be executed when the request fails. This block has no return value and takes one argument: a NSError.
 */
- (void)unsubscribeForNotifications:(void(^)())success failure:(void(^)(NSError *))failure;

/**
 Sends push notification to users with qbIds.
 
 @param params NSDictionary in the format in which you want to send the push.
 @param qbIds Quickblox ids of the users to receive the push.
 @param success A block object to be executed when the push is successfully sent. This block has no return value and takes no argument.
 @param failure A block object to be executed when the push fails. This block has no return value and takes one argument: a NSError.
 
 */
- (void)sendPushWithDictionary:(NSDictionary *)params
              toUsersWithQbIds:(NSArray *)qbIds
                       success:(void(^)())success
                       failure:(void(^)(NSError *))failure;

/**
 Removes occupants from dialog
 
 @param occupantIds occupants's quickbloxIds to remove
 @param dialogId The dialog's ID
 @param success A block object to be executed when the removal is successful. This block has no return value and takes a QBChatDialog as an argument.
 @param failure A block object to be executed when the pop fails. This block has no return value and takes one argument: a NSError.
 
 */
- (void)removeOccupants:(NSArray *)occupantIds
       fromDialogWithId:(NSString *)dialogId
                success:(void(^)(QBChatDialog *))success
                failure:(void(^)(NSError *))failure;

/**
 Adds occupants from dialog
 
 @param occupantIds occupants's quickbloxIds to add
 @param dialogId The dialog's ID
 @param success A block object to be executed when the request is successful. This block has no return value and takes a QBChatDialog as an argument.
 @param failure A block object to be executed when the push fails. This block has no return value and takes one argument: a NSError.
 
 */
- (void)addOccupants:(NSArray *)occupantIds
       fromDialogWithId:(NSString *)dialogId
                success:(void(^)(QBChatDialog *))success
                failure:(void(^)(NSError *))failure;

@end
