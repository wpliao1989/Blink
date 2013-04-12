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
@class BKUserOrderListCell;
@class BKOrderForReceiving;

@interface UIViewController (Formatter)

- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice;
- (NSString *)currencyStringForPrice:(NSNumber *)price;

@end

@interface UIViewController (ShopListCell)

- (NSString *)stringForDistance:(NSNumber *)distance;
- (NSString *)stringForDeliveryCostAndDistanceLabelOfShopInfo:(BKShopInfo *)shopInfo;
- (NSString *)stringForDeliverCostAndServiceOfShopInfo:(BKShopInfo *)shopInfo;
- (void)configureShopListCell:(BKShopListCell *)cell withShopInfo:(BKShopInfo *)shopInfo;
- (UIImage *)defaultPicture;
- (void)downloadImageForShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(UIImage *))completeHandler;
- (void)setImageView:(UIImageView *)imageView withImage:(UIImage *)image;

@end

@interface UIViewController (UserOrderListCell)

- (void)configureUserOrderListCell:(BKUserOrderListCell *)cell withOrder:(BKOrderForReceiving *)order;

@end