//
//  UserListViewModelSpec.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/30/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "UserListViewModel.h"

SpecBegin(UserListViewModel)

__block UserListViewModel *userListViewModel;

beforeEach(^{
    WLXQuickBloxUtils *quickbloxUtils = mock([WLXQuickBloxUtils class]);
    userListViewModel = [[UserListViewModel alloc] initWithQuickbloxUtils:quickbloxUtils];
});

describe(@"#title", ^{
    
    it(@"returns the user list title", ^{
        expect(userListViewModel.title).to.equal([NSLocalizedString(@"user_list_title", nil) uppercaseString]);
    });
    
});

describe(@"#count", ^{
    
    __block UserViewModel *viewModel;
    
    before(^{
        QBUUser *user = [[QBUUser alloc] init];
        user.ID = 123456;
        viewModel = [[UserViewModel alloc] initWithQBUUser:user];
        [userListViewModel addUser:viewModel];
    });
    
    it(@"increases the count", ^{
        expect(userListViewModel.count).to.equal(1);
    });
    
    it(@"increases has the received view model", ^{
        expect([userListViewModel objectAtIndex:0]).to.equal(viewModel);
    });
    
});

describe(@"#resetData", ^{
    
    __block UserViewModel *viewModel;
    
    before(^{
        QBUUser *user = [[QBUUser alloc] init];
        user.ID = 123456;
        viewModel = [[UserViewModel alloc] initWithQBUUser:user];
        [userListViewModel addUser:viewModel];
        [userListViewModel resetData];
    });
    
    it(@"resets the count", ^{
        expect(userListViewModel.count).to.equal(0);
    });
    
});

describe(@"#objectAtIndex:", ^{
    
    __block UserViewModel *viewModel;
    
    before(^{
        QBUUser *user = [[QBUUser alloc] init];
        user.ID = 123456;
        viewModel = [[UserViewModel alloc] initWithQBUUser:user];
        [userListViewModel addUser:viewModel];
    });
    
    it(@"has the view model", ^{
        expect([userListViewModel objectAtIndex:0]).to.equal(viewModel);
    });
    
});

SpecEnd
