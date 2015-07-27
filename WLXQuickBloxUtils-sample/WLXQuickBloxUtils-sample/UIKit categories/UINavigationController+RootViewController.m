//
//  UINavigationController+RootViewController.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "UINavigationController+RootViewController.h"

@implementation UINavigationController (RootViewController)

- (id)rootViewController {
    return self.viewControllers.firstObject;
}

@end
