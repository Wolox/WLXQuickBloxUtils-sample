//
//  TabBarViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "TabBarViewModel.h"
#import "NSString+CapitalizeFirstWord.h"
#import "ConversationListViewModel.h"
#import "UserListViewModel.h"

@interface TabBarViewModel ()

@property (strong, nonatomic) WLXQuickBloxUtils *quickbloxUtils;
@property (strong, nonatomic) NSDictionary *tabBarItemViewModels;
@property (strong, nonatomic) NSDictionary *tabBarItemTitles;

@property (strong, nonatomic) UserListViewModel *userListViewModel;
@property (strong, nonatomic) ConversationListViewModel *conversationListViewModel;

@end

@implementation TabBarViewModel

#pragma mark - Initializers

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils {
    self = [super init];
    if(self) {
        _quickbloxUtils = quickbloxUtils;
        _userListViewModel = [[UserListViewModel alloc] initWithQuickbloxUtils:_quickbloxUtils];
        _conversationListViewModel = [[ConversationListViewModel alloc] initWithQuickbloxUtils:_quickbloxUtils];
        [self initTabBarItemViewModels];
        [self initTabBarItemTitles];
    }
    return self;
}

- (void)initTabBarItemViewModels {
    self.tabBarItemViewModels = @{@(UserListTabBarIndex): self.userListViewModel,
                                  @(ConversationListTabBarIndex): self.conversationListViewModel};
}

- (void)initTabBarItemTitles {
    self.tabBarItemTitles = @{@(UserListTabBarIndex): [NSLocalizedString(@"user_list_title", nil) capitalizeFirstWord],
                              @(ConversationListTabBarIndex): [NSLocalizedString(@"conversation_list_title", nil) capitalizeFirstWord]};
}

#pragma mark - Tab Bar Info

- (id)tabBarItemViewModelAtIndex:(NSUInteger)index {
    return self.tabBarItemViewModels[@(index)];
}

- (NSString *)tabBarItemTitleAtIndex:(NSUInteger)index {
    return self.tabBarItemTitles[@(index)];
}

@end
