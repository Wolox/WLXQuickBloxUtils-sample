//
//  Application.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"

@interface Application : NSObject

+ (Application *)sharedInstance;

@property (strong, nonatomic) WLXQuickBloxUtils *quickbloxUtils;

@end
