//
//  UIView+makeToast.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/10/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "UIView+makeToast.h"
#import "UIView+Toast.h"

@implementation UIView (makeToast)

- (void)makeToastWithText:(NSString *)text {
    [self makeToast:text duration:2.0f position:CSToastPositionBottom];
}

@end
