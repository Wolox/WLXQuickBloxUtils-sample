//
//  TabBarViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"
#import "UserListViewModel.h"

typedef enum {
    UserListTabBarIndex
}TabBarIndex;

@interface TabBarViewModel : NSObject

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils;

- (NSString *)titleAtIndex:(TabBarIndex)index;
- (id)tabBarItemViewModelAtIndex:(NSUInteger)index;

@end
