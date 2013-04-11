//
//  BKOrder.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKOrderContentForSending;

@interface BKOrderForSending : NSObject

@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *shopID;
//@property (nonatomic, strong) NSString *recordTime;
//@property (nonatomic, strong) NSDate *recordTime;
@property (nonatomic, strong) NSNumber *recordTime; // Unix time
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;

// Content is an array of BKOrderContent
@property (nonatomic, strong) NSMutableArray *content;

@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *method;

- (void)addNewOrderContent:(BKOrderContentForSending *)content completeHandler:(void (^)(NSInteger updatedRow, BOOL isNewItemAdded)) completeHandler;
- (void)deleteOrderContentAtIndex:(NSInteger)index;
- (BKOrderContentForSending *)orderContentAtIndex:(NSInteger)index;
- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index;
- (NSUInteger)numberOfOrderContents;

@property (nonatomic, strong) NSNumber *totalPrice;
- (void)updateTotalPrice;

- (BKOrderForSending *)orderForAPI;

- (void)printValuesOfProperties;

@end
