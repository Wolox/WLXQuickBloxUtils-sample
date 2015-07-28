//
//  CollectionViewModel.h
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/27/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionViewModel : NSObject

@property (readonly, nonatomic) NSUInteger pageNumber;
@property (readonly, nonatomic) BOOL isLastPage;
@property (readonly, nonatomic) NSUInteger amountPerPage;

- (instancetype)initWithAmountPerPage:(NSUInteger)amountPerPage;

- (void)addPage:(NSArray *)resources;

- (id)objectAtIndex:(NSUInteger)index;

- (void)reset;

- (NSUInteger)count;

- (BOOL)isEndOfPage:(NSUInteger)index;

- (void)addResource:(id)resource;

- (void)addResource:(id)resource atIndex:(NSUInteger)index;

@end
