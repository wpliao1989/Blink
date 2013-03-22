//
//  BKTestCenter.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKOrder;
@class BKOrderContent;

@interface BKTestCenter : NSObject

+ (NSArray *)testShopInfos;
+ (NSArray *)testFavoriteShops;
+ (BKOrder *)testOrder;
+ (BKOrderContent *)testOrderContent;

+ (void)testPrint;
+ (void)testMethods;

@end
