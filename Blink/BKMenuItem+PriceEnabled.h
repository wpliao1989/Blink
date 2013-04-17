//
//  BKMenuItem+PriceEnabled.h
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuItem.h"

@interface BKMenuItem (PriceEnabled)

- (BOOL)isLargePriceEnabled;
- (BOOL)isMediumPriceEnabled;
- (BOOL)isSmallPriceEnabled;

- (NSNumber *)largePrice;
- (NSNumber *)mediumPrice;
- (NSNumber *)smallPrice;

@end
