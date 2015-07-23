//
//  UserViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "UserViewModel.h"

@interface UserViewModel ()

@property (strong, nonatomic) QBUUser *user;

@end

@implementation UserViewModel

- (instancetype)initWithQBUUser:(QBUUser *)user {
    self = [super init];
    if(self) {
        _user = user;
    }
    return self;
}

@end
