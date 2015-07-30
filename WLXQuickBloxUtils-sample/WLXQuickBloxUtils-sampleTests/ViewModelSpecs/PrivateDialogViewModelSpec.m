//
//  PrivateDialogViewModelSpec.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/30/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "PrivateDialogViewModel.h"
#import "DateTools.h"

SpecBegin(PrivateDialogViewModel)

__block QBChatDialog *dialog;
__block PrivateDialogViewModel *privateDialogViewModel;
__block UserViewModel *otherUserViewModel;
__block QBUUser *currentUser;

beforeEach(^{
    QBUUser *otherUser = [[QBUUser alloc] init];
    otherUser.login = @"email@email.com";
    otherUser.ID = 987654;
    currentUser = [[QBUUser alloc] init];
    currentUser.ID = 1234567;
    
    WLXQuickBloxUtils *quickbloxUtils = mock([WLXQuickBloxUtils class]);
    [given([quickbloxUtils currentUser]) willReturn:currentUser];
    
    dialog = [[QBChatDialog alloc] initWithDialogID:@"myDialogId"];
    
    otherUserViewModel = [[UserViewModel alloc] initWithQBUUser:otherUser];
    privateDialogViewModel = [[PrivateDialogViewModel alloc] initWithDialog:dialog quickbloxUtils:quickbloxUtils userViewModel:otherUserViewModel];
});

describe(@"#title", ^{
    
    it(@"returns the other user's email/login", ^{
        expect(privateDialogViewModel.title).to.equal(otherUserViewModel.email);
    });
    
});

describe(@"#senderId", ^{
    
    it(@"returns the current user's senderId", ^{
        expect(privateDialogViewModel.senderId).to.equal(currentUser.ID);
    });
    
});

describe(@"#lastMessage", ^{
    
    before(^{
        dialog.lastMessageText = @"this is the last message";
    });
    
    it(@"returns the last message sent", ^{
        expect(privateDialogViewModel.lastMessage).to.equal(dialog.lastMessageText);
    });
    
});

describe(@"#lastMessageDate", ^{
    
    before(^{
        dialog.lastMessageDate = [NSDate new];
    });
    
    it(@"returns the last message's sent date", ^{
        expect(privateDialogViewModel.lastMessageDate).to.equal([dialog.lastMessageDate timeAgoSinceNow]);
    });
    
});

describe(@"#addMessage:", ^{
    
    __block QBChatMessage *message;
    
    before(^{
        message = [[QBChatMessage alloc] init];
        message.text = @"the message's text";
        [privateDialogViewModel addMessage:message];
    });
    
    it(@"increases the count", ^{
        expect(privateDialogViewModel.count).to.equal(1);
    });
    
    it(@"has a MessageViewModel representing the message", ^{
        expect((MessageViewModel *)[privateDialogViewModel objectAtIndex:0].text).to.equal(message.text);
    });
    
});

describe(@"#addMessage:receivedAt:", ^{
    
    __block NSString *text;
    __block NSDate *date;
    
    before(^{
        text = @"the message's text";
        date = [NSDate new];
        [privateDialogViewModel addMessage:text receivedAt:date];
    });
    
    it(@"increases the count", ^{
        expect(privateDialogViewModel.count).to.equal(1);
    });
    
    it(@"has a MessageViewModel with the message's text", ^{
        expect((MessageViewModel *)[privateDialogViewModel objectAtIndex:0].text).to.equal(text);
    });
    
    it(@"has a MessageViewModel with the received date", ^{
        expect((MessageViewModel *)[privateDialogViewModel objectAtIndex:0].date).to.equal(date);
    });
    
});

describe(@"#count", ^{
    
    before(^{
        [privateDialogViewModel addMessage:@"a message" receivedAt:[NSDate new]];
    });
    
    it(@"increases the count", ^{
        expect(privateDialogViewModel.count).to.equal(1);
    });
    
});

describe(@"#resetData", ^{
    
    before(^{
        [privateDialogViewModel addMessage:@"a message" receivedAt:[NSDate new]];
        [privateDialogViewModel resetData];
    });
    
    it(@"resets the count", ^{
        expect(privateDialogViewModel.count).to.equal(0);
    });
    
});

describe(@"#objectAtIndex:", ^{
    
    __block NSString *message;
    
    before(^{
        message = @"a message";
        [privateDialogViewModel addMessage:message receivedAt:[NSDate new]];
    });
    
    it(@"increases the count", ^{
        expect((MessageViewModel *)[privateDialogViewModel objectAtIndex:0].text).to.equal(message);
    });
    
});

describe(@"#isOutgoing:", ^{
    
    __block MessageViewModel *messageViewModel;
    
    context(@"when the message is sent from the other user", ^{
       
        before(^{
            QBChatMessage *message = [[QBChatMessage alloc] init];
            message.senderID = otherUserViewModel.qbId;
            messageViewModel = [[MessageViewModel alloc] initWithQBChatMessage:message];
        });
        
        it(@"returns YES", ^{
            expect([privateDialogViewModel isOutgoing:messageViewModel]).to.equal(NO);
        });
        
    });
    
    context(@"when the message isn't sent from the other user", ^{
        
        before(^{
            QBChatMessage *message = [[QBChatMessage alloc] init];
            message.senderID = otherUserViewModel.qbId - 1;
            messageViewModel = [[MessageViewModel alloc] initWithQBChatMessage:message];
        });
        
        it(@"returns NO", ^{
            expect([privateDialogViewModel isOutgoing:messageViewModel]).to.equal(YES);
        });
        
    });
    
});

SpecEnd
