//
//  UIViewController+ShopListCell.h
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@class BKShopInfoForUser;
@class BKShopListCell;

@interface UIViewController (ShopListCell)

- (NSString *)stringForDistance:(NSNumber *)distance;
- (NSString *)stringForDeliveryCostAndDistanceLabelOfShopInfo:(BKShopInfoForUser *)shopInfo;
- (NSString *)stringForDeliverCostAndServiceOfShopInfo:(BKShopInfoForUser *)shopInfo;
- (void)configureShopListCell:(BKShopListCell *)cell withShopInfo:(BKShopInfoForUser *)shopInfo;
- (void)downloadImageForShopInfo:(BKShopInfoForUser *)shopInfo completeHandler:(void (^)(UIImage *))completeHandler;
- (void)setImageView:(UIImageView *)imageView withImage:(UIImage *)image;

@end