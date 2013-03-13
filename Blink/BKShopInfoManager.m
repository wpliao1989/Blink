//
//  BKShopInfoManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfoManager.h"
#import "BKShopInfo.h"

@interface BKShopInfoManager ()

//@property (strong, nonatomic) NSMutableArray *shopInfos;

@property (strong, nonatomic) NSMutableDictionary *shopInfoDictionary;
@property (strong, nonatomic) NSMutableArray *shopIDs;

@end

@implementation BKShopInfoManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKShopInfoManager)

//@synthesize shopInfos = _shopInfos;

@synthesize shopInfoDictionary = _shopInfoDictionary;
@synthesize shopIDs = _shopIDs;

//- (NSMutableArray *)shopInfos {
//    if (_shopInfos == nil) {
//        _shopInfos = [NSMutableArray array];
//    }
//    return _shopInfos;
//}

- (NSMutableDictionary *)shopInfoDictionary {
    if (_shopInfoDictionary == nil) {
        _shopInfoDictionary = [NSMutableDictionary dictionary];
    }
    return _shopInfoDictionary;
}

- (NSMutableArray *)shopIDs {
    if (_shopIDs == nil) {
        _shopIDs = [NSMutableArray array];
    }
    return _shopIDs;
}

- (NSUInteger)shopCount {
    return self.shopIDs.count;
}

- (NSString *)shopNameAtIndex:(NSUInteger)index {
    return ((BKShopInfo *)[self.shopInfoDictionary objectForKey:[self.shopIDs objectAtIndex:index]]).name;
}

- (NSString *)shopIDAtIndex:(NSUInteger)index {
    return [self.shopIDs objectAtIndex:index];
}

- (BKShopInfo *)shopInfoAtIndex:(NSUInteger)index {
    NSLog(@"ShopInfoAtIndex: [self.shopIDs objectAtIndex:index]: %@", [self.shopIDs objectAtIndex:index]);
    return [self.shopInfoDictionary objectForKey:[self.shopIDs objectAtIndex:index]];
}

- (BKShopInfo *)shopInfoForShopID:(NSString *)shopID {
    return [self.shopInfoDictionary objectForKey:shopID];
}

- (void)updateShopIDs:(NSArray *)shopIDs {
    self.shopIDs = [shopIDs mutableCopy];
}

- (void)addShopInfoWithRawData:(id)rawData forShopID:(NSString *)shopID {
    // Assume rawData is a dictionary
    if (rawData == [NSNull null]) {
        NSLog(@"Warning: data for shop id %@ is NSNull!", shopID);
        return;
    }
    
    if ([self.shopInfoDictionary objectForKey:shopID] == nil) {
        NSLog(@"Add new shop info for key %@", shopID);
        BKShopInfo *newShopInfo = [[BKShopInfo alloc] initWithData:rawData];
        newShopInfo.shopID = shopID;
        [self.shopInfoDictionary setObject:newShopInfo forKey:shopID];
    }
    else {
        BKShopInfo *oldShopInfo = [self.shopInfoDictionary objectForKey:shopID];
        NSLog(@"Replace shop info for key %@", shopID);
//        NSLog(@"oldShopInfo.name: %@", oldShopInfo.name);
//        NSLog(@"newShopInfo.name: %@", [rawData objectForKey:@"name"]);
        [oldShopInfo updateWithData:rawData];
    }
}

- (void)addShopInfosWithRawDatas:(NSArray *)rawDatas forShopIDs:(NSArray *)shopIDs {
    if (rawDatas.count != shopIDs.count) {
        NSLog(@"Warning: rawData.count != shopIDs.count!");
    }
    
    for (int i = 0; i < rawDatas.count; i++) {
        [self addShopInfoWithRawData:[rawDatas objectAtIndex:i] forShopID:[shopIDs objectAtIndex:i]];
    }
}

- (void)clearShopIDs {
    self.shopIDs = nil;
}

- (void)printShopIDs {
    NSLog(@"BKShopInfoManager test print!");
    NSLog(@"ShopIDs: %@", self.shopIDs);
}

//- (void)addShopInfoWithRawData:(NSDictionary *)rawData {
//    // Translate rawData
////    NSLog(@"rawData is %@", rawData);
//    
//    BKShopInfo *newShopInfo = [[BKShopInfo alloc] initWithData:rawData];
////    NSLog(@"newShopInfo %@", newShopInfo);
//    [self.shopInfos addObject:newShopInfo];
////    NSLog(@"add %@", self.shopInfos);
//}

//- (void)clearShopInfos {
//    self.shopInfos = nil;
//}

@end
