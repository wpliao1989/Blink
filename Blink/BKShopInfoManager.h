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

@property (strong, nonatomic) NSMutableArray *shopInfos;

- (NSUInteger)shopCount;
- (NSString *)shopNameAtIndex:(NSUInteger)index;
- (void)addShopInfoWithRawData:(id)rawData;

@end
