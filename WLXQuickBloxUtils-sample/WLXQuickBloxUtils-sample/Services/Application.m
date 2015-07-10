//
//  Application.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "Application.h"

#define kQBAppId @"QB_APP_ID"
#define kQBRegisterKey @"QB_SERVICE_KEY"
#define kQBRegisterSecret @"QB_SERVICE_SECRET"
#define kQBAccountKey @"QB_ACCOUNT_KEY"

@interface Application ()

@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation Application

+ (Application *)sharedInstance {
    static dispatch_once_t pred;
    static Application *shared = nil;
    dispatch_once(&pred, ^{
        shared = [Application new];
        shared.userInfo = [[NSBundle mainBundle] infoDictionary];
        shared.quickbloxUtils = [shared initializeQuickbloxUtils];
    });
    return shared;
}

- (WLXQuickBloxUtils *)initializeQuickbloxUtils {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSUInteger appId = [[f numberFromString:self.userInfo[kQBAppId]] integerValue];
    return [[WLXQuickBloxUtils alloc] initWithAppId:appId
                                        registerKey:(NSString *)self.userInfo[kQBRegisterKey]
                                     registerSecret:(NSString *)self.userInfo[kQBRegisterSecret]
                                         accountKey:(NSString *)self.userInfo[kQBAccountKey]];
}

@end
