//
//  BKOrder.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderForSending.h"
#import "BKOrderContentForSending.h"

NSString *const kBKTotalPriceDidChangeNotification = @"kBKTotalPriceDidChangeNotification";

@interface BKOrderForSending ()

// Return already existed orderContent if the UUID, name, ice, sweetness are all the same, return nil otherwise
- (BKOrderContentForSending *)hasOrderContent:(BKOrderContentForSending *)anotherOrderContent;

@end

@implementation BKOrderForSending

@synthesize userToken = _userToken;
@synthesize shopID = _shopID;
@synthesize recordTime = _recordTime;
@synthesize address = _address;
@synthesize phone = _phone;
@synthesize content = _content;
@synthesize totalPrice = _totalPrice;

- (NSMutableArray *)content {
    if (_content == nil) {
        _content = [NSMutableArray array];
    }
    return _content;
}

- (NSNumber *)totalPrice {
    if (_totalPrice == nil) {
        _totalPrice = [NSNumber numberWithDouble:0.0];
    }
    return _totalPrice;
}

- (void)setTotalPrice:(NSNumber *)totalPrice {    
    if ([_totalPrice doubleValue]!=[totalPrice doubleValue]) {
        _totalPrice = totalPrice;
        [[NSNotificationCenter defaultCenter] postNotificationName:kBKTotalPriceDidChangeNotification object:nil];
        return;
    }    
    _totalPrice = totalPrice;   
}

- (void)addNewOrderContent:(BKOrderContentForSending *)content completeHandler:(void (^)(NSInteger, BOOL))completeHandler{
    BKOrderContentForSending *orderContentToBeModified = [self hasOrderContent:content];
    
    if (orderContentToBeModified != nil) {
        orderContentToBeModified.quantity = [NSNumber numberWithInt:([orderContentToBeModified.quantity intValue]+[content.quantity intValue])];
        completeHandler([self.content indexOfObject:orderContentToBeModified], NO);
    }
    else {
        [self.content addObject:content];
        completeHandler(self.content.count-1, YES);
    }    
}

- (void)deleteOrderContentAtIndex:(NSInteger)index {
    NSLog(@"%d", index);
    [self.content removeObjectAtIndex:index];
}

- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index {
    BKOrderContentForSending *theContent = [self.content objectAtIndex:index];
    theContent.quantity = quantity;
}

#warning Must fill out empty properties before submission
- (BKOrderForSending *)orderForAPI {
    assert(self.userToken);
    assert(self.name);
    assert(self.shopID);
    assert(self.recordTime);
    assert(self.address);
    assert(self.phone);
    assert(self.note);
    assert(self.method);
    
    BKOrderForSending *theOrder = [[BKOrderForSending alloc] init];
    theOrder.userToken = self.userToken;
    theOrder.name = self.name;
    theOrder.shopID = self.shopID;
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateStyle = NSDateFormatterShortStyle;
//    formatter.timeStyle = NSDateFormatterShortStyle;
    //theOrder.recordTime = self.recordTime != nil ? self.recordTime : [NSDate date];
    theOrder.recordTime = self.recordTime;
    
    theOrder.address = self.address;
    theOrder.phone = self.phone;
    theOrder.note = self.note;
    theOrder.method = self.method;
    
    NSMutableArray *newContensArray = [NSMutableArray array];
    for (BKOrderContentForSending *content in self.content) {
        NSDictionary *newContent = [content contentForAPI];
        [newContensArray addObject:newContent];
    }
    theOrder.content = newContensArray;
    
//    NSLog(@"theOrder.content = %@", self.content);
    return theOrder;
}

- (void)updateTotalPrice {
    double totalPrice = 0.0;
    for (BKOrderContentForSending *orderContent in self.content) {
        totalPrice = totalPrice + [[orderContent priceValue] doubleValue];
    }
    self.totalPrice = [NSNumber numberWithDouble:totalPrice];
}

- (BKOrderContentForSending *)hasOrderContent:(BKOrderContentForSending *)anotherOrderContent {   
    
    for (BKOrderContentForSending *theOrderContent in self.content) {
        if ([theOrderContent isEqualExceptQuantity:anotherOrderContent]) {
            return theOrderContent;
        }
    }
    return nil;
}

- (NSString *)description {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[super description]];
    [result addObject:[NSString stringWithFormat:@"userToken:%@", self.userToken]];
    [result addObject:[NSString stringWithFormat:@"shopID:%@", self.shopID]];
    [result addObject:[NSString stringWithFormat:@"shopName:%@", self.shopName]];
    
    return [result componentsJoinedByString:@"\n\t"];
}

@end
