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

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils;

- (void)login:(void(^)(UserViewModel *))success failure:(void(^)(NSString *))failure;

- (void)signup:(void(^)(UserViewModel *))success failure:(void(^)(NSString *))failure;

- (void)validate:(void(^)(BOOL, NSString *))afterValidateBlock;

@end
