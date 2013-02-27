//
//  BKShopInfoManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@class BKShopInfo;

@interface BKShopInfoManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKShopInfoManager)

- (NSUInteger)shopCount;
- (NSString *)shopNameAtIndex:(NSUInteger)index;
- (NSString *)shopIDAtIndex:(NSUInteger)index;
- (BKShopInfo *)shopInfoAtIndex:(NSUInteger)index;
- (BKShopInfo *)shopInfoForShopID:(NSString *)shopID;

- (void)updateShopIDs:(NSArray *)shopIDs;
- (void)addShopInfoWithRawData:(id)rawData forShopID:(NSString *)shopID;
- (void)clearShopIDs;

//- (void)addShopInfoWithRawData:(id)rawData;


@end
