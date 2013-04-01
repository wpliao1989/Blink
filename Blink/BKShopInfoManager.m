//
//  BKShopInfoManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfoManager.h"
#import "BKShopInfo.h"
#import "BKAPIManager.h"

NSString *const BKShopImageDidDownloadNotification = @"BKShopImageDidDownloadNotification";
NSString *const kBKShopImageDidDownloadUserInfoShopInfo = @"kBKShopImageDidDownloadUserInfoShopInfo";

@interface BKShopInfoManager ()

//@property (strong, nonatomic) NSMutableArray *shopInfos;

@property (strong, nonatomic) NSMutableDictionary *shopInfoDictionary;
@property (strong, nonatomic) NSArray *shopIDs;
@property (strong, nonatomic) NSMutableDictionary *activeImageDownloads; // Key is sShopID, value is shopInfo

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

- (NSMutableDictionary *)activeImageDownloads {
    if (_activeImageDownloads == nil) {
        _activeImageDownloads = [NSMutableDictionary dictionary];
    }
    return _activeImageDownloads;
}

#pragma mark - Shop info query

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

#pragma mark - Load data

- (void)loadDataWithListCriteria:(NSInteger)criteria completeHandler:(loadDataComplete)completeHandler {
    [[BKAPIManager sharedBKAPIManager] loadDataWithListCriteria:criteria completeHandler:^(NSArray *shopIDs, NSArray *rawDatas) {
        self.shopIDs = shopIDs;
        [self addShopInfosWithRawDatas:rawDatas forShopIDs:shopIDs];
        completeHandler();
    }];
}

- (void)loadDataWithSortCriteria:(NSInteger)criteria completeHandler:(loadDataComplete)completeHandler {
    [[BKAPIManager sharedBKAPIManager] loadDataWithSortCriteria:criteria completeHandler:^(NSArray *shopIDs, NSArray *rawDatas) {
        self.shopIDs = shopIDs;
        [self addShopInfosWithRawDatas:rawDatas forShopIDs:shopIDs];
        completeHandler();
    }];
}

#pragma mark - Shop info update

- (void)updateShopIDs:(NSArray *)shopIDs {
    self.shopIDs = shopIDs;
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
        newShopInfo.sShopID = shopID;
        [self.shopInfoDictionary setObject:newShopInfo forKey:shopID];
    }
    else {
        BKShopInfo *oldShopInfo = [self.shopInfoDictionary objectForKey:shopID];
        NSLog(@"Replace shop info for key %@", shopID);
//        NSLog(@"oldShopInfo.name: %@", oldShopInfo.name);
//        NSLog(@"newShopInfo.name: %@", [rawData objectForKey:@"name"]);
//        [oldShopInfo updateWithData:rawData sShopID:shopID];
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

#pragma mark - Shop image download

- (void)downloadImageForShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(UIImage *))completeHandler {
    [self.activeImageDownloads setObject:shopInfo forKey:shopInfo.sShopID];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:shopInfo.pictureURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //            NSLog(@"pic response: %@", response);
        //            NSLog(@"pic data: %@", data);
        //            NSLog(@"pic error: %@", error);
        UIImage *pic = [UIImage imageWithData:data];        
        shopInfo.pictureImage = pic;
        [self.activeImageDownloads removeObjectForKey:shopInfo.sShopID];
        completeHandler(pic);
        NSDictionary *userInfo = @{kBKShopImageDidDownloadUserInfoShopInfo:shopInfo};
        [[NSNotificationCenter defaultCenter] postNotificationName:BKShopImageDidDownloadNotification object:nil userInfo:userInfo];
    }];
}

- (BOOL)isDownloadingImageForShopInfo:(BKShopInfo *)shopInfo {
    return [self.activeImageDownloads objectForKey:shopInfo.sShopID] != nil;
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
