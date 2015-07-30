//
//  ConversationListViewModelSpec.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/30/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "ConversationListViewModel.h"
#import "PrivateDialogViewModel.h"

SpecBegin(ConversationListViewModel)

__block PrivateDialogViewModel *privateDialogViewModel;
__block ConversationListViewModel *conversationListViewModel;
__block WLXQuickBloxUtils *quickbloxUtils;

beforeEach(^{
    quickbloxUtils = mock([WLXQuickBloxUtils class]);
    [given(quickbloxUtils.currentUser) willReturn:[[QBUUser alloc] init]];
    conversationListViewModel = [[ConversationListViewModel alloc] initWithQuickbloxUtils:quickbloxUtils];
});

describe(@"#title", ^{
    
    it(@"returns the title", ^{
        expect(conversationListViewModel.title).to.equal([NSLocalizedString(@"conversation_list_title", nil) uppercaseString]);
    });
    
});

describe(@"#selectedDialogViewModel", ^{
    
    __block PrivateDialogViewModel *viewModel;
    
    before(^{
        QBChatDialog *dialog = [[QBChatDialog alloc] init];
        dialog.ID = @"dialogId";
        dialog.lastMessageText = @"last message";
        UserViewModel *userViewModel = [[UserViewModel alloc] initWithQBUUser:quickbloxUtils.currentUser];
        viewModel = [[PrivateDialogViewModel alloc] initWithDialog:dialog quickbloxUtils:quickbloxUtils userViewModel:userViewModel];
        conversationListViewModel.selectedViewModel = viewModel;
    });
    
    it(@"returns the selected dialog", ^{
        expect(conversationListViewModel.selectedViewModel.lastMessage).to.equal(viewModel.lastMessage);
    });
    
});

describe(@"#count", ^{
    
    
    __block PrivateDialogViewModel *viewModel;
    
    before(^{
        QBChatDialog *dialog = [[QBChatDialog alloc] init];
        dialog.ID = @"dialogId";
        dialog.lastMessageText = @"last message";
        UserViewModel *userViewModel = [[UserViewModel alloc] initWithQBUUser:quickbloxUtils.currentUser];
        viewModel = [[PrivateDialogViewModel alloc] initWithDialog:dialog quickbloxUtils:quickbloxUtils userViewModel:userViewModel];
        [conversationListViewModel addDialog:viewModel];
    });
    
    it(@"increases the count", ^{
        expect(conversationListViewModel.count).to.equal(1);
    });
    
    it(@"increases has the received view model", ^{
        expect([conversationListViewModel objectAtIndex:0]).to.equal(viewModel);
    });
    
});

describe(@"#resetData", ^{
    
    __block PrivateDialogViewModel *viewModel;
    
    before(^{
        QBChatDialog *dialog = [[QBChatDialog alloc] init];
        dialog.ID = @"dialogId";
        dialog.lastMessageText = @"last message";
        UserViewModel *userViewModel = [[UserViewModel alloc] initWithQBUUser:quickbloxUtils.currentUser];
        viewModel = [[PrivateDialogViewModel alloc] initWithDialog:dialog quickbloxUtils:quickbloxUtils userViewModel:userViewModel];
        [conversationListViewModel addDialog:viewModel];
        [conversationListViewModel resetData];
    });
    
    it(@"resets the count", ^{
        expect(privateDialogViewModel.count).to.equal(0);
    });
    
});

describe(@"#objectAtIndex:", ^{
    
    __block PrivateDialogViewModel *viewModel;
    
    before(^{
        QBChatDialog *dialog = [[QBChatDialog alloc] init];
        dialog.ID = @"dialogId";
        dialog.lastMessageText = @"last message";
        UserViewModel *userViewModel = [[UserViewModel alloc] initWithQBUUser:quickbloxUtils.currentUser];
        viewModel = [[PrivateDialogViewModel alloc] initWithDialog:dialog quickbloxUtils:quickbloxUtils userViewModel:userViewModel];
        [conversationListViewModel addDialog:viewModel];
    });
    
    it(@"has the view model", ^{
        expect([conversationListViewModel objectAtIndex:0]).to.equal(viewModel);
    });
    
});

SpecEnd
