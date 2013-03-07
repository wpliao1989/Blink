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
#import "BKShopInfo.h"

#import "BKTestCenter.h"

//@interface NSString (ShopIDComparison)
//
//- (BOOL)isEqualToShopID:(NSString *)shopID;
//
//@end
//
//@implementation NSString (ShopIDComparison)
//
//- (BOOL)isEqualToShopID:(NSString *)shopID {
//    if ((self == nil) && (shopID == nil)) {
//        return YES;
//    }
//}
//
//@end

@interface BKOrderManager ()

@property (strong, nonatomic) BKShopInfo *shopInfo;

- (BOOL)isDifferentShop:(BKShopInfo *)anotherShopInfo;
- (void)ifNoContentLeftThenClear;

@end

@implementation BKOrderManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKOrderManager)

@synthesize order = _order;
@synthesize shopInfo = _shopInfo;

- (BKOrder *)order {
    if (_order == nil) {
        _order = [[BKOrder alloc] init];
    }
    return _order;
}

- (void)setShopInfo:(BKShopInfo *)shopInfo {
    if (shopInfo != _shopInfo) {
        self.order.shopID = shopInfo.shopID;
    }
    _shopInfo = shopInfo;
}

//- (BOOL)isValidOrder {
//    return YES;
//}

- (void)setUserToken:(NSString *)token userName:(NSString *)name userPhone:(NSString *)phone userAddress:(NSString *)address {
    self.order.userToken = token;    
    self.order.phone = phone;
    self.order.address = address;
}

- (void)sendOrderWithCompleteHandler:(void (^)(BOOL))completeHandler {
//    BKOrder *testDict = [BKTestCenter testOrder];
    [[BKAPIManager sharedBKAPIManager] orderWithData:[self.order orderForAPI] completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        NSLog(@"data %@", data);
        NSLog(@"response %@", response);
        NSLog(@"error %@", error);
        if (data == nil || error != nil) {
            completeHandler(NO);
        }
        else {
            completeHandler(YES);
        }
    }];   
}

#pragma mark - Order content operations

- (BOOL)isDifferentShop:(BKShopInfo *)anotherShopInfo {
    return (self.shopInfo != nil) && (![self.shopInfo.shopID isEqualToString:anotherShopInfo.shopID]);
}

- (BOOL)hasOrder {
    return self.shopInfo != nil;
}

- (BOOL)addNewOrderContent:(BKOrderContent *)content forShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(NSInteger, BOOL))completeHandler {
//    NSLog(@"%@", self.shopInfo);
//    NSLog(@"%@", shopInfo);
    
    if ([self isDifferentShop:shopInfo]) {
        NSLog(@"Warning: order exists!");
        return NO;
    }
    else {
        self.shopInfo = shopInfo;
        [self.order addNewOrderContent:content completeHandler:completeHandler];
        [self.order updateTotalPrice];
        return YES;
    }
    
//    NSLog(@"number of order content: %d", [self numberOfOrderContents]);
//    [self.order printValuesOfProperties];
}

- (void)deleteOrderContentAtIndex:(NSInteger)index {
    [self.order deleteOrderContentAtIndex:index];
    [self.order updateTotalPrice];
    [self ifNoContentLeftThenClear];
}

- (BKOrderContent *)orderContentAtIndex:(NSInteger)index {
    return [self.order orderContentAtIndex:index];
}

//- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index {
//    [self.order modifyOrderContentQuantity:quantity AtIndex:index];
//}

- (NSUInteger)numberOfOrderContentsForShopInfo:(BKShopInfo *)shopInfo {
//    NSLog(@"%@", self.shopInfo.shopID);
//    NSLog(@"%@", shopInfo.shopID);
    
    if ([self isDifferentShop:shopInfo]) {
//        NSLog(@"123");
        return 0;
    }
    return [self.order numberOfOrderContents];
}

- (void)ifNoContentLeftThenClear {
    if (([self.order numberOfOrderContents] == 0) && ([self.order.note length] == 0)) {
        [self clear];
    }
}

#pragma Total price / Note

- (NSString *)noteForShopInfo:(BKShopInfo *)shopInfo {
    if ([self isDifferentShop:shopInfo]) {
        return nil;
    }
    return self.order.note;
}

- (void)saveNote:(NSString *)theNote forShopInfo:(BKShopInfo *)shopInfo{
    self.shopInfo = shopInfo;
    self.order.note = theNote;
    [self ifNoContentLeftThenClear];
}

- (NSNumber *)totalPrice {
    return self.order.totalPrice;
}

- (NSString *)shopName {
    return self.shopInfo.name;
}

- (NSString *)shopID {
    return self.shopInfo.shopID;
}

- (void)clear {
    self.order = nil;
    self.shopInfo = nil;
}

@end
