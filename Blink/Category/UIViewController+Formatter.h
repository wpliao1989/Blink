//
//  UIViewController+Formatter.h
//  Blink
//
//  Created by 維平 廖 on 13/4/10.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKShopInfo;
@class BKShopListCell;

@interface UIViewController (Formatter)

- (NSString *)stringForDeliveryCostAndDistanceLabelOfShopInfo:(BKShopInfo *)shopInfo;
- (NSString *)stringForDeliverCostAndServiceOfShopInfo:(BKShopInfo *)shopInfo;
- (NSString *)currencyStringForPrice:(NSNumber *)price;
- (NSString *)stringForDistance:(NSNumber *)distance;
- (void)configureCell:(BKShopListCell *)cell withShopInfo:(BKShopInfo *)shopInfo;

@end
