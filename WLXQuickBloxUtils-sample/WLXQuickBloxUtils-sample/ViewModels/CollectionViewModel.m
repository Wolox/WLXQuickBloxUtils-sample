//
//  CollectionViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import "CollectionViewModel.h"

@interface CollectionViewModel ()

@property (strong, nonatomic) NSMutableArray *resources;

@end

@implementation CollectionViewModel

- (instancetype)initWithAmountPerPage:(NSUInteger)amountPerPage {
    self = [super init];
    if(self) {
        _pageNumber = 1;
        _isLastPage = NO;
        _resources = [NSMutableArray array];
        _amountPerPage = amountPerPage;
    }
    return self;
}

- (void)saveResources:(NSArray *)resources {
    [self.resources addObjectsFromArray:resources];
    if(resources.count < self.amountPerPage) {
        _isLastPage = YES;
    }
}

- (void)reset {
    [self.resources removeAllObjects];
    _isLastPage = NO;
    _pageNumber = 1;
}

- (id)objectAtIndex:(NSUInteger)index {
    return self.resources[index];
}

- (BOOL)isEndOfPage:(NSUInteger)index {
    return (self.isLastPage == NO) && ((index + 1) % self.amountPerPage == 0);
}

- (NSUInteger)count {
    return self.resources.count;
}

@end
