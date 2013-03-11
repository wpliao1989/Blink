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

//- (BOOL)isValidOrder;
- (void)setOrderTime:(NSDate *)date;
- (void)setUserToken:(NSString *)token userName:(NSString *)name userPhone:(NSString *)phone userAddress:(NSString *)address;
- (void)sendOrderWithCompleteHandler:(void (^)(BOOL success, NSError *error))completeHandler;

- (BOOL)addNewOrderContent:(BKOrderContent *)content forShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(NSInteger updatedRow, BOOL isNewItemAdded)) completeHandler;
- (void)deleteOrderContentAtIndex:(NSInteger)index;
- (BKOrderContent *)orderContentAtIndex:(NSInteger)index;
//- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index;
- (NSUInteger)numberOfOrderContentsForShopInfo:(BKShopInfo *)shopInfo;

- (NSString *)noteForShopInfo:(BKShopInfo *)shopInfo;
- (void)saveNote:(NSString *)theNote forShopInfo:(BKShopInfo *)shopInfo;

- (BOOL)hasOrder;
- (NSNumber *)totalPrice;
- (NSString *)shopName;
- (NSString *)shopID;
- (void)clear;

@end
