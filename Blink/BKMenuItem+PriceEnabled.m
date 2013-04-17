//
//  BKMenuItem+PriceEnabled.m
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuItem+PriceEnabled.h"

@implementation BKMenuItem (PriceEnabled)

- (BOOL)isLargePriceEnabled {
    return [self.price objectForKey:kBKMenuPriceLarge] != nil;
}

- (BOOL)isMediumPriceEnabled {
    return [self.price objectForKey:kBKMenuPriceMedium] != nil;
}

- (BOOL)isSmallPriceEnabled {
    return [self.price objectForKey:kBKMenuPriceSmall] != nil;
}

- (NSNumber *)largePrice {
    return [self isLargePriceEnabled] ? self.price[kBKMenuPriceLarge] : @(0);
}

- (NSNumber *)mediumPrice {
    return [self isMediumPriceEnabled] ? self.price[kBKMenuPriceMedium] : @(0);
}

- (NSNumber *)smallPrice {
    return [self isSmallPriceEnabled] ? self.price[kBKMenuPriceSmall] : @(0);
}

@end
