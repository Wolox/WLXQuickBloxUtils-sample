//
//  MessageViewModelSpec.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/30/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "MessageViewModel.h"

SpecBegin(MessageViewModel)

__block QBChatMessage *message;
__block MessageViewModel *messageViewModel;

beforeEach(^{
    message = [[QBChatMessage alloc] init];
    messageViewModel = [[MessageViewModel alloc] initWithQBChatMessage:message];
});

describe(@"#text", ^{
    
    before(^{
        message.text = @"the message's text";
    });
    
    it(@"returns the message's text", ^{
        expect(messageViewModel.text).to.equal(message.text);
    });
    
});

describe(@"#senderId", ^{
    
    before(^{
        message.senderID = 123456;
    });
    
    it(@"returns the message's senderId", ^{
        expect(messageViewModel.senderId).to.equal(message.senderID);
    });
    
});

describe(@"#recipientId", ^{
    
    before(^{
        message.senderID = 123456;
    });
    
    it(@"returns the message's recipientId", ^{
        expect(messageViewModel.recipientId).to.equal(message.recipientID);
    });
    
});

describe(@"#date", ^{
    
    before(^{
        message.dateSent = [NSDate new];
    });
    
    it(@"returns the message's recipientId", ^{
        expect(messageViewModel.date).to.equal(message.dateSent);
    });
    
});

describe(@"#qbMessageId", ^{
    
    before(^{
        message.ID = @"MessageID";
    });
    
    it(@"returns the message's ID", ^{
        expect(messageViewModel.qbMessageId).to.equal(message.ID);
    });
    
});

describe(@"#qbMessageId", ^{
    
    before(^{
        message.ID = @"MessageID";
    });
    
    it(@"returns the message's ID", ^{
        expect(messageViewModel.qbMessageId).to.equal(message.ID);
    });
    
});

describe(@"#dateAttributedString", ^{
    
    before(^{
        message.dateSent = [NSDate new];
    });
    
    it(@"returns the message's ID", ^{
        expect(messageViewModel.dateAttributedString).to.equal([[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.dateSent]);
    });
    
});

describe(@"#jsqMessage", ^{
    
    before(^{
        message.senderID = 123456;
        message.dateSent = [NSDate new];
    });
        
    it(@"has the message's senderId", ^{
        expect([messageViewModel jsqMessage].senderId).to.equal([@(message.senderID) stringValue]);
    });
    
    it(@"has no sender display name", ^{
        expect([messageViewModel jsqMessage].senderDisplayName).to.equal(@"");
    });
    
    it(@"has the message's date", ^{
        expect([messageViewModel jsqMessage].date).to.equal(message.dateSent);
    });
    
    context(@"when the message is empty", ^{
        
        it(@"has an empty message", ^{
            expect([messageViewModel jsqMessage].text).to.equal(@" ");
        });
        
    });
    
    context(@"when the message is not empty", ^{
        
        before(^{
            message.text = @"Some text";
        });
        
        it(@"has the message's text", ^{
            expect([messageViewModel jsqMessage].text).to.equal(message.text);
        });
        
    });
    
});

SpecEnd
