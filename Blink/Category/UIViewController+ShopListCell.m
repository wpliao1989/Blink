//
//  UIViewController+ShopListCell.m
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+ShopListCell.h"
#import "BKShopInfo.h"
#import "BKShopListCell.h"
#import "BKShopInfoManager.h"
#import "NSNumber+NullNumber.h"
#import "UIViewController+Formatter.m"

@implementation UIViewController (ShopListCell)

- (NSString *)stringForDistance:(NSNumber *)distance {
    if ([distance isEqualToNumber:[NSNumber nullNumber]]) {
        return nil;
    }
    double kmValue = round([distance doubleValue]);
    //    NSLog(@"distanceValue %f", kmValue);
    
    if (kmValue < 1.0) {
        double mValue = floor(kmValue * 1000);
        return [NSString stringWithFormat:@"距離%d公尺", (int)mValue];
    }
    
    return [NSString stringWithFormat:@"距離%d公里", (NSInteger)kmValue];
}

- (void)configureShopListCell:(BKShopListCell *)cell withShopInfo:(BKShopInfo *)shopInfo {
    if (shopInfo.pictureImage == nil) {
        cell.imageView.image = [self defaultPicture];
    }
    else {
        cell.imageView.image = shopInfo.pictureImage;
    }
    
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

- (void)downloadImageForShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(UIImage *))completeHandler {
    [[BKShopInfoManager sharedBKShopInfoManager] downloadImageForShopInfo:shopInfo completeHandler:completeHandler];
}

- (void)setImageView:(UIImageView *)imageView withImage:(UIImage *)image {
    if (image) {
        imageView.image = image;
    }
    else {
        imageView.image = [self defaultPicture];
    }
}

@end
