//
//  BKOrder.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKOrderContent;

//FOUNDATION_EXPORT NSString *const kBKOrderUserToken;
//FOUNDATION_EXPORT NSString *const kBKOrderShopID;
//FOUNDATION_EXPORT NSString *const kBKOrderRecordTime;
//FOUNDATION_EXPORT NSString *const kBKOrderUserAddress;
//FOUNDATION_EXPORT NSString *const kBKOrderUserPhone;
//FOUNDATION_EXPORT NSString *const kBKOrderContent;

FOUNDATION_EXPORT NSString *const kBKOrderMethodDelivery;
FOUNDATION_EXPORT NSString *const kBKOrderMethodTakeout;

@interface BKOrder : NSObject

@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *recordTime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;

// Content is an array of BKOrderContent
@property (nonatomic, strong) NSMutableArray *content;

@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *method;

- (void)addNewOrderContent:(BKOrderContent *)content completeHandler:(void (^)(NSInteger updatedRow, BOOL isNewItemAdded)) completeHandler;
- (void)deleteOrderContentAtIndex:(NSInteger)index;
- (BKOrderContent *)orderContentAtIndex:(NSInteger)index;
- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index;
- (NSUInteger)numberOfOrderContents;

@property (nonatomic, strong) NSNumber *totalPrice;
- (void)updateTotalPrice;

- (BKOrder *)orderForAPI;

- (void)printValuesOfProperties;

@end
