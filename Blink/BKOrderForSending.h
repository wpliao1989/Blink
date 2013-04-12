//
//  BKOrder.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKOrderContentForSending;

#import "BKOrder.h"

@interface BKOrderForSending : BKOrder

@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSMutableArray *content;
@property (nonatomic, strong) NSString *method;

- (void)addNewOrderContent:(BKOrderContentForSending *)content completeHandler:(void (^)(NSInteger updatedRow, BOOL isNewItemAdded)) completeHandler;
- (void)deleteOrderContentAtIndex:(NSInteger)index;
- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index;

- (void)updateTotalPrice;

- (BKOrderForSending *)orderForAPI;

@end
