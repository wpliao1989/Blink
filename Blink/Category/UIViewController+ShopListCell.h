//
//  UIViewController+ShopListCell.h
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKShopInfo;
@class BKShopListCell;

@interface UIViewController (ShopListCell)

- (NSString *)stringForDistance:(NSNumber *)distance;
- (NSString *)stringForDeliveryCostAndDistanceLabelOfShopInfo:(BKShopInfo *)shopInfo;
- (NSString *)stringForDeliverCostAndServiceOfShopInfo:(BKShopInfo *)shopInfo;
- (void)configureShopListCell:(BKShopListCell *)cell withShopInfo:(BKShopInfo *)shopInfo;
- (void)downloadImageForShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(UIImage *))completeHandler;
- (void)setImageView:(UIImageView *)imageView withImage:(UIImage *)image;

@end