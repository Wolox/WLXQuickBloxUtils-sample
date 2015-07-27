//
//  NSString+capitalizeFirstWord.m
//  ToBuy
//
//  Created by Damian on 1/5/15.
//  Copyright (c) 2015 wolox. All rights reserved.
//

#import "NSString+CapitalizeFirstWord.h"

@implementation NSString (CapitalizeFirstWord)

- (NSString*)CapitalizeFirstWord {
    if(self.length == 0) {
        return self;
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}

@end
