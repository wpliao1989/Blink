//
//  UIViewController+Formatter.m
//  Blink
//
//  Created by 維平 廖 on 13/4/10.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+Formatter.h"
#import "BKShopInfo.h"
#import "BKShopListCell.h"
#import "BKUserOrderListCell.h"
#import "BKOrderForReceiving.h"

@implementation UIViewController (Formatter)

- (NSString *)currencyStringForPrice:(NSNumber *)price {
    static NSNumberFormatter *currencyFormatter;
    
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setPositiveFormat:@"¤#,###"];
        NSLocale *twLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"];
        [currencyFormatter setLocale:twLocale];
        [currencyFormatter setCurrencySymbol:@"$"];
        //        NSLog(@"positive format: %@", [currencyFormatter positiveFormat]);
    }
    
    return [currencyFormatter stringFromNumber:price];
}

- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice {
    //    static NSString *preString = @"總金額: ";
    static NSString *postString = @"元";
    NSString *result = [NSString stringWithFormat:@"%@%@", [totalPrice stringValue], postString];
    return result;
}

@end

@implementation UIViewController (ShopListCell)

- (NSString *)stringForDistance:(NSNumber *)distance {
    double kmValue = round([distance doubleValue]);
    //    NSLog(@"distanceValue %f", kmValue);
    
    if (kmValue < 1.0) {
        double mValue = floor(kmValue * 1000);
        return [NSString stringWithFormat:@"距離%d公尺", (int)mValue];
    }
    
    return [NSString stringWithFormat:@"距離%d公里", (NSInteger)kmValue];
}

- (void)configureShopListCell:(BKShopListCell *)cell withShopInfo:(BKShopInfo *)shopInfo {
    UIImage *backgroundImage = [UIImage imageNamed:@"list"];
    UIImage *pressImage = [UIImage imageNamed:@"list_press"];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:pressImage];
    
    // Configure shop name
    cell.shopNameLabel.text = shopInfo.name;
    
    // Configure deliver price and distance
    //        CLLocation *shopLocation = theShopInfo.shopLocaiton;
    
    cell.priceAndDistanceLabel.text = [self stringForDeliveryCostAndDistanceLabelOfShopInfo:shopInfo];
    
    // Configure commerce type
    cell.commerceTypeLabel.text = [shopInfo localizedTypeString];
    
    // Configure score
    NSInteger shopScore = [shopInfo.score intValue];
    if (shopScore <= ((BKShopListCell *)cell).scoreImageViews.count) {
        for (NSInteger i = 0; i < shopScore; i++) {
            UIImageView *scoreImageView = [((BKShopListCell *)cell).scoreImageViews objectAtIndex:i];
            scoreImageView.image = [UIImage imageNamed:@"star_press"];
        }
    }
}

- (NSString *)stringForDeliveryCostAndDistanceLabelOfShopInfo:(BKShopInfo *)shopInfo {
    NSMutableArray *strings = [NSMutableArray array];
    NSString *deliverCostString = [self stringForDeliverCostAndServiceOfShopInfo:shopInfo];
    NSString *distanceString = [self stringForDistance:shopInfo.distance];
    if (deliverCostString.length > 0) {
        [strings addObject:deliverCostString];
    }
    if (distanceString.length > 0) {
        [strings addObject:distanceString];
    }
    return [strings componentsJoinedByString:@"，"];
}

- (NSString *)stringForDeliverCostAndServiceOfShopInfo:(BKShopInfo *)shopInfo {
    static NSString *freeDelivery = @"免費外送";
    static NSString *chargeDelivery = @"自費外送";
    NSString *minPirce = [self currencyStringForPrice:shopInfo.minPrice];
    
    NSMutableArray *strings = [NSMutableArray arrayWithObject:minPirce];
    
    
    if ([shopInfo isServiceFreeDelivery]) {
        [strings addObject:freeDelivery];
        return [strings componentsJoinedByString:@""];
    }
    else if ([shopInfo isServiceHasDeliveryCost]) {
        [strings addObject:chargeDelivery];
        return [strings componentsJoinedByString:@""];
    }
    else {
        return [NSString stringWithFormat:@""];
    }
}


@end

@implementation UIViewController (UserOrderListCell)

- (void)configureUserOrderListCell:(BKUserOrderListCell *)cell withOrder:(BKOrderForReceiving *)order {
    UIImage *backgroundImage = [UIImage imageNamed:@"list"];
    UIImage *pressImage = [UIImage imageNamed:@"list_press"];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:pressImage];
    
    cell.totalPriceLabel.text = [self stringForTotalPrice:order.totalPrice];
    cell.shopNameLabel.text = order.shopName;
    
    cell.statusImageView.image = nil;
    cell.statusImageView.image = [UIImage imageNamed:@"circle"];
    if ([order.status isEqualToString:BKOrderItemStatusSent]) {
        
    }
    else if ([order.status isEqualToString:BKOrderItemStatusProccessed]) {
        
    }
    else if ([order.status isEqualToString:BKOrderItemStatusDelivered]) {
        
    }
    else if ([order.status isEqualToString:BKOrderItemStatusFinished]) {
        cell.statusImageView.image = [UIImage imageNamed:@"circle"];
    }
    else {
        //assert(true);
    }
}

@end