//
//  BKOrderManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/18.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@class BKOrderForSending;
@class BKOrderContentForSending;
@class BKShopInfo;

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSUInteger, BKOrderMethod) {
    BKOrderMethodDelivery = 0,
    BKOrderMethodTakeout = 1
};

FOUNDATION_EXPORT NSString *const kBKTotalPriceDidChangeNotification;

@interface BKOrderManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKOrderManager)

@property (nonatomic, strong) BKOrderForSending *order;
@property (nonatomic, strong, readonly) NSDate *recordTime;

// ------------------------------------------------------------------
// Configure order
// ------------------------------------------------------------------
- (void)setOrderTime:(NSDate *)date;
- (void)setUserToken:(NSString *)token userName:(NSString *)name userPhone:(NSString *)phone userAddress:(NSString *)address;
- (void)setOrderMethod:(BKOrderMethod)method;

// ------------------------------------------------------------------
// Order content
// ------------------------------------------------------------------
- (BOOL)addNewOrderContent:(BKOrderContentForSending *)content forShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(NSInteger updatedRow, BOOL isNewItemAdded)) completeHandler;
- (void)deleteOrderContentAtIndex:(NSInteger)index;
- (BKOrderContentForSending *)orderContentAtIndex:(NSInteger)index;
//- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index;
- (NSUInteger)numberOfOrderContentsForShopInfo:(BKShopInfo *)shopInfo;

// ------------------------------------------------------------------
// Note
// ------------------------------------------------------------------
- (NSString *)noteForShopInfo:(BKShopInfo *)shopInfo;
- (BOOL)saveNote:(NSString *)theNote forShopInfo:(BKShopInfo *)shopInfo; // return YES for successful saving, NO otherwise

// ------------------------------------------------------------------
// Info
// ------------------------------------------------------------------
- (NSNumber *)totalPriceForShop:(BKShopInfo *)shopInfo;
- (NSString *)shopName;
- (NSString *)shopID;

// ------------------------------------------------------------------
// Operation
// ------------------------------------------------------------------
//- (BOOL)isValidOrder;
- (void)sendOrderWithCompleteHandler:(void (^)(BOOL success, NSError *error))completeHandler;
- (BOOL)hasOrder;
- (void)clear;

@end
