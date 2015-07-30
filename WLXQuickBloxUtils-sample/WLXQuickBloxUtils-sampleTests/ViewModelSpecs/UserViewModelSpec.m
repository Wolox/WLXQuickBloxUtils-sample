//
//  UserViewModelSpec.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/29/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "UserViewModel.h"

SpecBegin(UserViewModel)

__block QBUUser *user;
__block UserViewModel *userViewModel;

beforeEach(^{
    userViewModel = [[UserViewModel alloc] initWithQBUUser:user];
});

describe(@"#email", ^{
   
    it(@"returns the user's email", ^{
        expect(userViewModel.email).to.equal(user.email);
    });
    
});

describe(@"#qbId", ^{
    
    it(@"returns the user's quickblox ID", ^{
        expect(userViewModel.qbId).to.equal(user.ID);
    });
    
});

describe(@"#talkButtonTitle", ^{
    
    it(@"returns the user's quickblox ID", ^{
        expect(userViewModel.talkButtonTitle).to.equal([NSLocalizedString(@"talk_button_title", nil) capitalizedString]);
    });
    
});

SpecEnd
