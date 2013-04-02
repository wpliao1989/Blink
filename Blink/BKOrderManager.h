//
//  BKOrderManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/18.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@class BKOrder;
@class BKOrderContent;
@class BKShopInfo;

FOUNDATION_EXPORT NSString *const kBKTotalPriceDidChangeNotification;

@interface BKOrderManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKOrderManager)

@property (nonatomic, strong) BKOrder *order;
@property (nonatomic, strong, readonly) NSDate *recordTime;

// ------------------------------------------------------------------
// Configure order
// ------------------------------------------------------------------
- (void)setOrderTime:(NSDate *)date;
- (void)setUserToken:(NSString *)token userName:(NSString *)name userPhone:(NSString *)phone userAddress:(NSString *)address;

// ------------------------------------------------------------------
// Order content
// ------------------------------------------------------------------
- (BOOL)addNewOrderContent:(BKOrderContent *)content forShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(NSInteger updatedRow, BOOL isNewItemAdded)) completeHandler;
- (void)deleteOrderContentAtIndex:(NSInteger)index;
- (BKOrderContent *)orderContentAtIndex:(NSInteger)index;
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
