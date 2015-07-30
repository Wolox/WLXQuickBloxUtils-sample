//
//  TabBarViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLXQuickBloxUtils.h"

typedef enum {
    UserListTabBarIndex,
    ConversationListTabBarIndex
}TabBarIndex;

@interface TabBarViewModel : NSObject

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils;

- (id)tabBarItemViewModelAtIndex:(NSUInteger)index;
- (NSString *)tabBarItemTitleAtIndex:(NSUInteger)index;

@end
