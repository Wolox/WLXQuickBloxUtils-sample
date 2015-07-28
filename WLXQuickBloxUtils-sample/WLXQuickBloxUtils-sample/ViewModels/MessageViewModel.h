//
//  MessageViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/28/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"
#import "JSQMessages.h"

@interface MessageViewModel : NSObject

- (instancetype)initWithQBChatMessage:(QBChatMessage *)message;

- (NSString *)text;
- (NSUInteger)senderId;
- (NSUInteger)recipientId;
- (NSDate *)date;
- (NSString *)qbMessageId;

- (id<JSQMessageData>)jsqMessage;
- (NSAttributedString *)dateAttributedString;
- (NSAttributedString *)attributedTitle:(NSString *)title;

@end
