//
//  TabBarViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "TabBarViewModel.h"
#import "NSString+CapitalizeFirstWord.h"

@interface TabBarViewModel ()

@property (strong, nonatomic) WLXQuickBloxUtils *quickbloxUtils;
@property (strong, nonatomic) NSDictionary *tabBarItemViewModels;

@property (strong, nonatomic) UserListViewModel *userListViewModel;

@end

@implementation TabBarViewModel

#pragma mark - Initializers

- (instancetype)initWithQuickbloxUtils:(WLXQuickBloxUtils *)quickbloxUtils {
    self = [super init];
    if(self) {
        _quickbloxUtils = quickbloxUtils;
        _userListViewModel = [[UserListViewModel alloc] initWithQuickbloxUtils:_quickbloxUtils];
        [self initTabBarItemViewModels];
    }
    return self;
}

- (void)initTabBarItemViewModels {
    self.tabBarItemViewModels = @{@(UserListTabBarIndex): self.userListViewModel};
}

#pragma mark - Tab Bar Info

- (NSString *)titleAtIndex:(TabBarIndex)index {
    NSString *title;
    switch(index) {
        case UserListTabBarIndex:
            title = [NSLocalizedString(@"user_list_tab_bar_title", nil) capitalizeFirstWord];
        default:
            return nil;
    }
    return title;
}

- (id)tabBarItemViewModelAtIndex:(NSUInteger)index {
    return self.tabBarItemViewModels[@(index)];
}

@end
