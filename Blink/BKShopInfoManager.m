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
    BKShopInfo *newShopInfo = [[BKShopInfo alloc] initWithData:rawData];
    [self.shopInfoDictionary setObject:newShopInfo forKey:shopID];
}

- (void)clearShopIDs {
    self.shopIDs = nil;
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
