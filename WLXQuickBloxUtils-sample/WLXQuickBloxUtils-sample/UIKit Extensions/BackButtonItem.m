//
//  BackButtonItem.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/28/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "BackButtonItem.h"
#import "NSString+CapitalizeFirstWord.h"

@implementation BackButtonItem

+ (BackButtonItem *)new {
    BackButtonItem *item = [[BackButtonItem alloc] initWithTitle:[NSLocalizedString(@"back", nil) capitalizeFirstWord]
                                                             style:UIBarButtonItemStylePlain
                                                            target:nil
                                                            action:nil];
    return item;
}

@end
