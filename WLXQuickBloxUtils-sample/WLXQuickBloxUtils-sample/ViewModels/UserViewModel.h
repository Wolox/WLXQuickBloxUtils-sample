//
//  UserViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"

@interface UserViewModel : NSObject

@property (strong, nonatomic) NSString *talkButtonTitle;

- (instancetype)initWithQBUUser:(QBUUser *)user;

- (NSString *)email;
- (NSUInteger)qbId;

@end
