//
//  LoginViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/29/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "LoginViewModel.h"
#import "NSString+CapitalizeFirstWord.h"

SpecBegin(LoginViewModel)

__block LoginViewModel *loginViewModel;

beforeEach(^{
    WLXQuickBloxUtils *quickbloxUtils = mock([WLXQuickBloxUtils class]);
    loginViewModel = [[LoginViewModel alloc] initWithQuickbloxUtils:quickbloxUtils];
});

describe(@"#email", ^{
    
    context(@"when the LoginViewModel is created", ^{
       
        it(@"has no email", ^{
            expect(loginViewModel.email).to.beNil;
        });
        
    });
    
    context(@"after settings the email", ^{
        
        __block NSString *email;
        
        before(^{
            email = [@(arc4random()) stringValue];
            loginViewModel.email = email;
        });
        
        it(@"returns the user's email", ^{
            expect(loginViewModel.email).to.equal(email);
        });
        
    });
    
});

describe(@"#password", ^{
    
    context(@"when the LoginViewModel is created", ^{
        
        it(@"has no password", ^{
            expect(loginViewModel.password).to.beNil;
        });
        
    });
    
    context(@"after settings the password", ^{
        
        __block NSString *password;
        
        before(^{
            password = [@(arc4random()) stringValue];
            loginViewModel.password = password;
        });
        
        it(@"returns the user's email", ^{
            expect(loginViewModel.password).to.equal(password);
        });
        
    });
    
});

describe(@"#emailPlaceholder", ^{
    
    it(@"returns the email placeholder text", ^{
        expect(loginViewModel.emailPlaceholder).to.equal([NSLocalizedString(@"email", nil) capitalizeFirstWord]);
    });
    
});

describe(@"#passwordPlaceholder", ^{
    
    it(@"returns the password placeholder text", ^{
        expect(loginViewModel.passwordPlaceholder).to.equal([NSLocalizedString(@"password", nil) capitalizeFirstWord]);
    });
    
});

describe(@"#loginButtonTitle", ^{
    
    it(@"returns the login button title", ^{
        expect(loginViewModel.loginButtonTitle).to.equal([NSLocalizedString(@"login_button_title", nil) capitalizeFirstWord]);
    });
    
});

describe(@"#signUpButtonTitle", ^{
    
    it(@"returns the signup button title", ^{
        expect(loginViewModel.signUpButtonTitle).to.equal([NSLocalizedString(@"signup_button_title", nil) capitalizeFirstWord]);
    });
    
});

describe(@"#tabBarViewModel", ^{
    
    it(@"returns a tabBarViewModel", ^{
        expect(loginViewModel.tabBarViewModel).notTo.equal(nil);
    });
    
});

describe(@"#validate", ^{
    
    context(@"when email is nil and valid password", ^{
        
        before(^{
            loginViewModel.password = @"123456789";
            loginViewModel.email = nil;
        });
        
        it(@"returns an error message", ^{
            [loginViewModel validate:^(BOOL valid, NSString *errorMSG) {
                expect(errorMSG).notTo.equal(nil);
                expect(valid).to.equal(NO);
            }];
        });
        
    });
    
    context(@"when email's format is invalid and valid password", ^{
        
        before(^{
            loginViewModel.password = @"123456789";
            loginViewModel.email = @"not a valid format";
        });
        
        it(@"returns an error message", ^{
            [loginViewModel validate:^(BOOL valid, NSString *errorMSG) {
                expect(errorMSG).notTo.equal(nil);
                expect(valid).to.equal(NO);
            }];
        });
        
    });
  
    context(@"when email is valid and password is nil", ^{
        
        before(^{
            loginViewModel.password = nil;
            loginViewModel.email = @"email@email.com";
        });
        
        it(@"returns an error message", ^{
            [loginViewModel validate:^(BOOL valid, NSString *errorMSG) {
                expect(errorMSG).notTo.equal(nil);
                expect(valid).to.equal(NO);
            }];
        });
        
    });
    
    context(@"when email is valid and password is too short", ^{
        
        before(^{
            loginViewModel.password = @"123";
            loginViewModel.email = @"email@email.com";
        });
        
        it(@"returns an error message", ^{
            [loginViewModel validate:^(BOOL valid, NSString *errorMSG) {
                expect(errorMSG).notTo.equal(nil);
                expect(valid).to.equal(NO);
            }];
        });
        
    });
    
    context(@"when both email and password are invalid", ^{
        
        before(^{
            loginViewModel.password = nil;
            loginViewModel.email = nil;
        });
        
        it(@"returns an error message", ^{
            [loginViewModel validate:^(BOOL valid, NSString *errorMSG) {
                expect(errorMSG).notTo.equal(nil);
                expect(valid).to.equal(NO);
            }];
        });
        
    });
    
    context(@"when both email and password are valid", ^{
        
        before(^{
            loginViewModel.password = @"123456789";
            loginViewModel.email = @"email@email.com";
        });
        
        it(@"returns an error message", ^{
            [loginViewModel validate:^(BOOL valid, NSString *errorMSG) {
                expect(errorMSG).to.equal(nil);
                expect(valid).to.equal(YES);
            }];
        });
        
    });
    
});

SpecEnd
