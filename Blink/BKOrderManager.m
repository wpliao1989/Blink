//
//  BKOrderManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/18.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderManager.h"
#import "BKAccountManager.h"
#import "BKAPIManager.h"
#import "BKOrder.h"
#import "BKOrderContent.h"

#import "BKTestCenter.h"

@interface BKOrderManager ()

@end

@implementation BKOrderManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKOrderManager)

@synthesize order = _order;

- (BKOrder *)order {
    if (_order == nil) {
        _order = [[BKOrder alloc] init];
    }
    return _order;
}

//- (BOOL)isValidOrder {
//    return YES;
//}

- (void)sendOrder {
//    BKOrder *testDict = [BKTestCenter testOrder];
    [[BKAPIManager sharedBKAPIManager] orderWithData:[self.order orderForAPI] completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        NSLog(@"%@", data);        
    }];   
}

#pragma mark - Order content operations

- (void)addNewOrderContent:(BKOrderContent *)content completeHandler:(void (^)(NSInteger, BOOL))completeHandler{
    [self.order addNewOrderContent:content completeHandler:completeHandler];
    [self.order updateTotalPrice];
//    NSLog(@"number of order content: %d", [self numberOfOrderContents]);
//    [self.order printValuesOfProperties];
}

- (void)deleteOrderContentAtIndex:(NSInteger)index {
    [self.order deleteOrderContentAtIndex:index];
    [self.order updateTotalPrice];
}

- (BKOrderContent *)orderContentAtIndex:(NSInteger)index {
    return [self.order orderContentAtIndex:index];
}

- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index {
    [self.order modifyOrderContentQuantity:quantity AtIndex:index];
}

- (NSUInteger)numberOfOrderContents {
    return [self.order numberOfOrderContents];
}

#pragma Total price / Note

- (NSString *)note {
    return self.order.note;
}

- (void)saveNote:(NSString *)theNote {
    self.order.note = theNote;    
}

- (NSNumber *)totalPrice {
    return self.order.totalPrice;
}

@end
