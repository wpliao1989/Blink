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
#import "BKOrderForSending.h"
#import "BKOrderContentForSending.h"
#import "BKShopInfoForUser.h"

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

@property (strong, nonatomic) BKShopInfoForUser *shopInfo;

- (BOOL)isDifferentShop:(BKShopInfoForUser *)anotherShopInfo;
- (void)ifNoContentLeftThenClear;

@end

@implementation BKOrderManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKOrderManager)

@synthesize order = _order;
@synthesize shopInfo = _shopInfo;
@synthesize recordTime = _recordTime;

- (BKOrderForSending *)order {
    if (_order == nil) {
        _order = [[BKOrderForSending alloc] init];
    }
    return _order;
}

- (void)setShopInfo:(BKShopInfoForUser *)shopInfo {
    if (shopInfo != _shopInfo) {
        self.order.shopID = shopInfo.sShopID;
    }
    _shopInfo = shopInfo;
}

- (NSDate *)recordTime {
    return self.order.recordTime;
}

//- (BOOL)isValidOrder {
//    return YES;
//}

- (void)setOrderTime:(NSDate *)date {
//    static NSDateFormatter *formatter;
//    if (formatter == nil) {
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
//        //        [formatter setDateStyle:NSDateFormatterShortStyle];
//        //        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        //        NSLog(@"formatter string: %@", formatter.dateFormat);
//    }
//    NSString *recordTime = [formatter stringFromDate:date];    
    self.order.recordTime = date;
    //NSLog(@"Order time is set to %@", self.order.recordTime);
    //NSLog(@"Readable time %@", [NSDate dateWithTimeIntervalSince1970:[self.order.recordTime doubleValue]]);
    //_recordTime = date;
}

- (void)setUserToken:(NSString *)token userName:(NSString *)name userPhone:(NSString *)phone userAddress:(NSString *)address {
    self.order.userToken = token;
    self.order.name = name;
    self.order.phone = phone;
    self.order.address = address;
}

- (void)sendOrderWithCompleteHandler:(void (^)(BOOL, NSError*))completeHandler {
//    BKOrder *testDict = [BKTestCenter testOrder];
    [[BKAPIManager sharedBKAPIManager] orderWithData:[self.order orderForAPI] completionHandler:^(id data, NSError *error) {
        NSLog(@"data %@", data);        
        NSLog(@"error %@", error);
        if (data == nil || error != nil) {
            completeHandler(NO, error);
        }
        else {
            completeHandler(YES, error);
        }
    }];   
}

- (void)setOrderMethod:(BKOrderMethod)method {
    switch (method) {
        case BKOrderMethodDelivery:
            self.order.method = kBKOrderMethodDelivery;
            break;
        case BKOrderMethodTakeout:
            self.order.method = kBKOrderMethodTakeout;
            break;
        default:
            NSLog(@"Warning: invalid BKOrderMethod!");
            break;
    }
}

#pragma mark - Order content operations

- (BOOL)isDifferentShop:(BKShopInfoForUser *)anotherShopInfo {
    return (self.shopInfo != nil) && (![self.shopInfo.sShopID isEqualToString:anotherShopInfo.sShopID]);
}

- (BOOL)hasOrder {
    return self.shopInfo != nil;
}

- (BOOL)addNewOrderContent:(BKOrderContentForSending *)content forShopInfo:(BKShopInfoForUser *)shopInfo completeHandler:(void (^)(NSInteger, BOOL))completeHandler {
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

- (BKOrderContentForSending *)orderContentAtIndex:(NSInteger)index {
    return [self.order orderContentAtIndex:index];
}

//- (void)modifyOrderContentQuantity:(NSNumber *)quantity AtIndex:(NSInteger)index {
//    [self.order modifyOrderContentQuantity:quantity AtIndex:index];
//}

- (NSUInteger)numberOfOrderContentsForShopInfo:(BKShopInfoForUser *)shopInfo {
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

#pragma mark - Total price / Note

- (NSString *)noteForShopInfo:(BKShopInfoForUser *)shopInfo {
    if ([self isDifferentShop:shopInfo]) {
        return nil;
    }
    return self.order.note;
}

- (BOOL)saveNote:(NSString *)theNote forShopInfo:(BKShopInfoForUser *)shopInfo{
    if ([self isDifferentShop:shopInfo]) {
        return NO;
    }
    self.shopInfo = shopInfo;
    self.order.note = theNote;
    [self ifNoContentLeftThenClear];
    return YES;
}

- (NSNumber *)totalPriceForShop:(BKShopInfoForUser *)shopInfo {
    if ([self isDifferentShop:shopInfo]) {
        return @(0);
    }
    return self.order.totalPrice;
}

#pragma mark - Order informations

- (NSString *)shopName {
    return self.shopInfo.name;
}

- (NSString *)shopID {
    return self.shopInfo.sShopID;
}

- (void)clear {
    self.order = nil;
    self.shopInfo = nil;
}

@end
