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
        _pageNumber = 0;
        _isLastPage = NO;
        _resources = [NSMutableArray array];
        _amountPerPage = amountPerPage;
    }
    return self;
}

- (void)addPage:(NSArray *)resources {
    [self.resources addObjectsFromArray:resources];
    _pageNumber++;
    if(resources.count < self.amountPerPage) {
        _isLastPage = YES;
    }
}

- (void)addResource:(id)resource {
    [self.resources addObject:resource];
}

- (void)addResource:(id)resource atIndex:(NSUInteger)index {
    [self.resources insertObject:resource atIndex:index];
}

- (void)reset {
    [self.resources removeAllObjects];
    _isLastPage = NO;
    _pageNumber = 0;
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
