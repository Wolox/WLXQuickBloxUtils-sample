//
//  LoginViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserViewModel.h"

@interface LoginViewModel : NSObject

@property (readonly, nonatomic) NSString *emailPlaceholder;
@property (readonly, nonatomic) NSString *passwordPlaceholder;
@property (readonly, nonatomic) NSString *loginButtonTitle;
@property (readonly, nonatomic) NSString *signUpButtonTitle;

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void(^)(UserViewModel *))success
               failure:(void(^)(NSString *))failure;

- (void)signUpWithEmail:(NSString *)email
               password:(NSString *)password
                success:(void(^)(UserViewModel *))success
                failure:(void(^)(NSString *))failure;

- (void)validateEmail:(NSString *)email
             password:(NSString *)password
        afterValidate:(void(^)(BOOL, NSString *))afterValidateBlock;

@end
