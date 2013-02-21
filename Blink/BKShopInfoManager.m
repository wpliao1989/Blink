//
//  BKShopInfoManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfoManager.h"
#import "BKShopInfo.h"

@implementation BKShopInfoManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKShopInfoManager)

@synthesize shopInfos = _shopInfos;

- (NSMutableArray *)shopInfos {
    if (_shopInfos == nil) {
        _shopInfos = [NSMutableArray array];
    }
    return _shopInfos;
}

- (NSUInteger)shopCount {
    return self.shopInfos.count;
}

- (NSString *)shopNameAtIndex:(NSUInteger)index {
    return ((BKShopInfo *)[self.shopInfos objectAtIndex:index]).name;
}

- (BKShopInfo *)shopInfoAtIndex:(NSUInteger)index {
    return [self.shopInfos objectAtIndex:index];
}

- (void)addShopInfoWithRawData:(NSDictionary *)rawData {
    // Translate rawData
    NSLog(@"rawData is %@", rawData);
    
    BKShopInfo *newShopInfo = [[BKShopInfo alloc] initWithData:rawData];
//    NSLog(@"newShopInfo %@", newShopInfo);
    [self.shopInfos addObject:newShopInfo];
//    NSLog(@"add %@", self.shopInfos);
}

- (void)clearShopInfos {
    self.shopInfos = nil;
}

@end
