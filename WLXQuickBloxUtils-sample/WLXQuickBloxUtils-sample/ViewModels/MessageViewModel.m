//
//  MessageViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/28/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "MessageViewModel.h"

@interface MessageViewModel ()

@property (strong, nonatomic) QBChatMessage *message;

@end

@implementation MessageViewModel

- (instancetype)initWithQBChatMessage:(QBChatMessage *)message {
    self = [super init];
    if(self) {
        _message = message;
    }
    return self;
}

- (NSString *)text {
    return _message.text;
}

- (NSUInteger)senderId {
    return _message.senderID;
}

- (NSUInteger)recipientId {
    return _message.recipientID;
}

- (NSDate *)date {
    return _message.dateSent;
}

- (NSString *)qbMessageId {
    return _message.ID;
}

#pragma mark - JSQMessage methods

- (id<JSQMessageData>)jsqMessage {
    return [[JSQMessage alloc] initWithSenderId:[@(_message.senderID) stringValue]
                              senderDisplayName:@""
                                           date:_message.dateSent
                                           text:self.message.text ? self.message.text : @" "]; // JSQMessage crashes if message is null
}

- (NSAttributedString *)dateAttributedString {
    return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:[self date]];
}

@end
