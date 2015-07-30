//
//  CollectionViewModel.m
//  WLXQuickBloxUtils-sample
//
//  Created by Damian on 7/29/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecHelper.h"
#import "CollectionViewModel.h"

SpecBegin(CollectionViewModel)

__block CollectionViewModel *collectionViewModel;
__block NSUInteger amountPerPage;

beforeEach(^{
    amountPerPage = MAX(1, arc4random_uniform(15));
    collectionViewModel = [[CollectionViewModel alloc] initWithAmountPerPage:amountPerPage];
});

describe(@"#pageNumber", ^{
    
    it(@"starts from the page 0", ^{
        expect(collectionViewModel.pageNumber).to.equal(0);
    });

});

describe(@"#count", ^{

    it(@"has no resources", ^{
        expect(collectionViewModel.count).to.equal(0);
    });
   
});

describe(@"#isLastPage", ^{
    
    it(@"returns NO", ^{
        expect(collectionViewModel.isLastPage).to.equal(NO);
    });
    
});

describe(@"#amountPerPage", ^{
    
    it(@"returns the amount epr page given in the init", ^{
        expect(collectionViewModel.amountPerPage).to.equal(amountPerPage);
    });
    
});

describe(@"#addPage", ^{
    
    __block NSMutableArray *resources;
    
    context(@"when the amount of resources added are the same as amountPerPage", ^{
       
        before(^{
            resources = [NSMutableArray array];
            for(int i = 0; i < amountPerPage; i++) {
                [resources addObject:@(i)];
            }
            [collectionViewModel addPage:resources];
        });
        
        it(@"increases the number of resources", ^{
            expect(collectionViewModel.count).to.equal(amountPerPage);
        });
        
        it(@"increases the page number", ^{
            expect(collectionViewModel.pageNumber).to.equal(1);
        });
        
        it(@"is not the last page", ^{
            expect(collectionViewModel.isLastPage).to.equal(NO);
        });
        
    });
    
    context(@"when the amount of resources added are the less than amountPerPage", ^{
        
        before(^{
            resources = [NSMutableArray array];
            for(int i = 0; i < amountPerPage - 1; i++) {
                [resources addObject:@(i)];
            }
            [collectionViewModel addPage:resources];
        });
        
        it(@"increases the number of resources", ^{
            expect(collectionViewModel.count).to.equal(amountPerPage - 1);
        });
        
        it(@"increases the page number", ^{
            expect(collectionViewModel.pageNumber).to.equal(1);
        });
        
        it(@"is not the last page", ^{
            expect(collectionViewModel.isLastPage).to.equal(YES);
        });
        
    });
    
});

describe(@"#objectAtIndex:", ^{
   
    __block NSString *object;
    
    before(^{
        object = @"an object";
        [collectionViewModel addResource:object];
    });
    
    it(@"returns the object stores in that index", ^{
        expect([collectionViewModel objectAtIndex:0]).to.equal(object);
    });
    
});

describe(@"#reset", ^{
    
    __block NSString *object;
    
    before(^{
        object = @"an object";
        [collectionViewModel addResource:object];
        [collectionViewModel reset];
    });
    
    it(@"resets the pageNumber", ^{
        expect(collectionViewModel.pageNumber).to.equal(0);
    });
    
    it(@"sets the isLastPage property to NO", ^{
        expect(collectionViewModel.isLastPage).to.equal(NO);
    });
    
    it(@"drops all the resources", ^{
        expect(collectionViewModel.count).to.equal(0);
    });
    
});

describe(@"isEndOfPage:", ^{
   
    context(@"when it's last page", ^{
        
        __block NSMutableArray *resources;
        
        before(^{
            resources = [NSMutableArray array];
            for(int i = 0; i < amountPerPage - 1; i++) {
                [resources addObject:@(i)];
            }
            [collectionViewModel addPage:resources];
        });
        
        it(@"returns NO", ^{
            expect([collectionViewModel isEndOfPage:arc4random()]).to.equal(NO);
        });
        
    });
    
    context(@"when it's not the last page", ^{
        
        __block NSUInteger lastIndex;
        
        before(^{
            id object = @1;
            collectionViewModel = [[CollectionViewModel alloc] initWithAmountPerPage:2];
            [collectionViewModel addResource:object];
            lastIndex = 1;
        });
        
        context(@"when the index passed is not the last one", ^{
            
            it(@"returns YES", ^{
                expect([collectionViewModel isEndOfPage:lastIndex - 1]).to.equal(NO);
            });
            
        });
        
        context(@"when the index passed is the last one", ^{
            
            it(@"returns YES", ^{
                expect([collectionViewModel isEndOfPage:lastIndex]).to.equal(YES);
            });
            
        });
        
    });

});

describe(@"addResource:", ^{
    
    __block NSUInteger currentCount;
    
    before(^{
        id object = @1;
        currentCount = collectionViewModel.count;
        [collectionViewModel addResource:object];
    });
    
    it(@"increases the count", ^{
        expect(collectionViewModel.count).to.equal(currentCount + 1);
    });
    
});

describe(@"addResource:atIndex", ^{
    
    __block NSUInteger currentCount;
    
    before(^{
        id firstObject = @1;
        [collectionViewModel addResource:firstObject];
        
        id secondObject = @2;
        currentCount = collectionViewModel.count;
        [collectionViewModel addResource:secondObject atIndex:0];
    });
    
    it(@"increases the count", ^{
        expect(collectionViewModel.count).to.equal(currentCount + 1);
    });
    
    it(@"places the object at the indicated index", ^{
        expect([collectionViewModel objectAtIndex:0]).to.equal(@2);
    });
    
});

SpecEnd
