//
//  BKTestCenter.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKOrderForSending;
@class BKOrderContentForSending;

@interface BKTestCenter : NSObject

+ (NSArray *)testShopInfos;
+ (NSArray *)testFavoriteShops;
+ (BKOrderForSending *)testOrder;
+ (BKOrderContentForSending *)testOrderContent;

+ (void)testPrint;
+ (void)testMethods;

@end
