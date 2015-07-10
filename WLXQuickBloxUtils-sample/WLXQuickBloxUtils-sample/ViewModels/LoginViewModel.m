//
//  LoginViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "LoginViewModel.h"
#import "NSString+capitalizeFirstWord.h"
#import "WLXQuickBloxUtils.h"

#define MIN_PASS_LENGTH 8

@interface LoginViewModel ()

@property (strong, nonatomic) WLXQuickBloxUtils *quickbloxUtils;

@end

@implementation LoginViewModel

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils {
    self = [super init];
    if(self) {
        _emailPlaceholder = [NSLocalizedString(@"email", nil) capitalizeFirstWord];
        _passwordPlaceholder = [NSLocalizedString(@"password", nil) capitalizeFirstWord];
        _loginButtonTitle = [NSLocalizedString(@"login_button_title", nil) capitalizeFirstWord];
        _signUpButtonTitle = [NSLocalizedString(@"signup_button_title", nil) capitalizeFirstWord];
        _quickbloxUtils = quickbloxUtils;
    }
    return self;
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void(^)(UserViewModel *))success
               failure:(void(^)(NSString *))failure {
    [self.quickbloxUtils logInWithAuthentication:email
                                        password:password
                                        delegate:nil
                                         success:^(QBUUser *user) {
                                             UserViewModel *userViewModel = [[UserViewModel alloc] initWithQBUUser:user];
                                             if(success) {
                                                 success(userViewModel);
                                             }
                                         } failure:^(NSError *error) {
                                             if(failure) {
                                                 failure([NSLocalizedString(@"login_error", nil) capitalizeFirstWord]);
                                             }
                                         }];
}

- (void)signUpWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void(^)(UserViewModel *))success
               failure:(void(^)(NSString *))failure {
    [self.quickbloxUtils signUpWithAuthentication:email
                                        password:password
                                        delegate:nil
                                         success:^(QBUUser *user) {
                                             UserViewModel *userViewModel = [[UserViewModel alloc] initWithQBUUser:user];
                                             if(success) {
                                                 success(userViewModel);
                                             }
                                         } failure:^(NSError *error) {
                                             if(failure) {
                                                 failure([NSLocalizedString(@"signup_error", nil) capitalizeFirstWord]);
                                             }
                                         }];
}

- (void)validateEmail:(NSString *)email
             password:(NSString *)password
        afterValidate:(void(^)(BOOL, NSString *))afterValidateBlock {
    BOOL validEmail = [self validateEmail:email];
    BOOL validPassword = [self validatePassword:password];
    if(validEmail && validPassword) {
        afterValidateBlock(YES, nil);
    } else {
        NSString *errorMessageKey = validEmail ? @"password_not_valid" : @"email_not_valid";
        afterValidateBlock(NO, [NSLocalizedString(errorMessageKey, nil) capitalizeFirstWord]);
    }
}

#pragma mark - Private methods

- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validatePassword:(NSString *)password {
    return password.length >= MIN_PASS_LENGTH;
}

@end
