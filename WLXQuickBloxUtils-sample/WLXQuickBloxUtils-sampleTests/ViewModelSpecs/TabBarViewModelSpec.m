//
//  TabBarViewModelSpec.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/30/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "TabBarViewModel.h"
#import "UserListViewModel.h"
#import "ConversationListViewModel.h"
#import "NSString+CapitalizeFirstWord.h"

SpecBegin(TabBarViewModel)

__block TabBarViewModel *tabBarViewModel;
__block WLXQuickBloxUtils *quickbloxUtils;

beforeEach(^{
    quickbloxUtils = mock([WLXQuickBloxUtils class]);
    tabBarViewModel = [[TabBarViewModel alloc] initWithQuickbloxUtils:quickbloxUtils];
});

describe(@"#tabBarItemViewModelAtIndex", ^{
    
    it(@"has the UserListViewModel in the first position", ^{
        expect([tabBarViewModel tabBarItemViewModelAtIndex:0]).to.beKindOf([UserListViewModel class]);
    });
    
    it(@"has the ConversationListViewModel in the second position", ^{
        expect([tabBarViewModel tabBarItemViewModelAtIndex:1]).to.beKindOf(ConversationListViewModel.class);
    });
    
});

describe(@"#tabBarItemTitleAtIndex:", ^{
    
    it(@"has the UserListViewModel in the first position", ^{
        expect([tabBarViewModel tabBarItemTitleAtIndex:0]).to.equal([NSLocalizedString(@"user_list_title", nil) capitalizeFirstWord]);
    });
    
    it(@"has the ConversationListViewModel in the second position", ^{
        expect([tabBarViewModel tabBarItemTitleAtIndex:1]).to.equal([NSLocalizedString(@"conversation_list_title", nil) capitalizeFirstWord]);
    });
    
});

SpecEnd
