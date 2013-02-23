//
//  BKOrder.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrder.h"
#import "BKOrderContent.h"

@implementation BKOrder

@synthesize userToken = _userToken;
@synthesize shopID = _shopID;
@synthesize recordTime = _recordTime;
@synthesize address = _address;
@synthesize phone = _phone;
@synthesize content = _content;
@synthesize note = _note;

- (NSMutableArray *)content {
    if (_content == nil) {
        _content = [NSMutableArray array];
    }
    return _content;
}

- (void)addNewOrderContent:(BKOrderContent *)content {
    [self.content addObject:content];
}

- (void)deleteOrderContentAtIndex:(NSInteger)index {
    NSLog(@"%d", index);
    [self.content removeObjectAtIndex:index];
}

- (BKOrderContent *)orderContentAtIndex:(NSInteger)index {
    return [self.content objectAtIndex:index];
}

- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index {
    BKOrderContent *theContent = [self.content objectAtIndex:index];
    theContent.quantity = quantity;
}

- (NSUInteger)numberOfOrderContents {
    return self.content.count;
}

- (BKOrder *)orderForAPI {
    BKOrder *theOrder = [[BKOrder alloc] init];
    theOrder.userToken = self.userToken != nil ? self.userToken : @"none";
    theOrder.shopID = self.shopID != nil ? self.shopID : @"none";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    theOrder.recordTime = [formatter stringFromDate:[NSDate date]];
    
    theOrder.address = self.address != nil ? self.address : @"none";
    theOrder.phone = self.phone != nil ? self.phone : @"none";
    theOrder.note = self.note != nil ? self.note : @"none";
    
    NSMutableArray *newContensArray = [NSMutableArray array];
    for (BKOrderContent *content in self.content) {
        NSDictionary *newContent = [content contentForAPI];
        [newContensArray addObject:newContent];
    }
    self.content = newContensArray;
    NSLog(@"self.content = %@", self.content);
    return theOrder;
}

- (void)printValuesOfProperties {
    NSLog(@"userToken is %@", self.userToken);
    NSLog(@"shopID is %@", self.shopID);
    NSLog(@"recordTime is %@", self.recordTime);
    NSLog(@"address is %@", self.address);
    NSLog(@"phone is %@", self.phone);
    NSLog(@"note is %@", self.note);
    NSLog(@"content is %@", self.content);
}

@end
