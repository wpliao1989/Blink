//
//  BKShopInfoManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfoManager.h"
#import "BKShopInfoForUser.h"
#import "BKAPIManager.h"
#import "BKSearchParameter.h"

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

- (NSArray *)shopIDs {
    if (_shopIDs == nil) {
        _shopIDs = @[];
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

- (NSUInteger)indexForShopID:(NSString *)shopID {
    return [self.shopIDs indexOfObject:shopID];
}

- (NSString *)shopNameAtIndex:(NSUInteger)index {
    return ((BKShopInfoForUser *)[self.shopInfoDictionary objectForKey:[self.shopIDs objectAtIndex:index]]).name;
}

- (NSString *)shopIDAtIndex:(NSUInteger)index {
    return [self.shopIDs objectAtIndex:index];
}

- (BKShopInfoForUser *)shopInfoAtIndex:(NSUInteger)index {
    NSLog(@"ShopInfoAtIndex: [self.shopIDs objectAtIndex:index]: %@", [self.shopIDs objectAtIndex:index]);
    return [self.shopInfoDictionary objectForKey:[self.shopIDs objectAtIndex:index]];
}

- (BKShopInfoForUser *)shopInfoForShopID:(NSString *)shopID {
    return [self.shopInfoDictionary objectForKey:shopID];
}

- (NSArray *)shopInfosForShopIDs:(NSArray *)shopIDs {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *theShopID in shopIDs) {
        BKShopInfoForUser *theShopInfo = [self shopInfoForShopID:theShopID];
        if (theShopInfo) {
            [result addObject:theShopInfo];
        }
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark - Load data

//- (void)loadDataWithListCriteria:(NSInteger)criteria completeHandler:(loadDataComplete)completeHandler {
//    BKSearchParameter *params = [[BKSearchParameter alloc] init];
//    params.method = @"11111";
//    
//    [[BKAPIManager sharedBKAPIManager] loadDataWithListCriteria:criteria parameter:params completeHandler:^(NSArray *shopIDs, NSArray *rawDatas) {
//        self.shopIDs = shopIDs;
//        [self addShopInfosWithRawDatas:rawDatas forShopIDs:shopIDs];
//        completeHandler();
//    }];
//}
//
//- (void)loadDataWithSortCriteria:(NSInteger)criteria completeHandler:(loadDataComplete)completeHandler {
//    BKSearchParameter *params = [[BKSearchParameter alloc] init];
//    params.method = @"22222";
//    
//    [[BKAPIManager sharedBKAPIManager] loadDataWithSortCriteria:criteria parameter:params completeHandler:^(NSArray *shopIDs, NSArray *rawDatas) {
//        self.shopIDs = shopIDs;
//        [self addShopInfosWithRawDatas:rawDatas forShopIDs:shopIDs];
//        completeHandler();
//    }];
//}

- (void)loadDataOption:(BKSearchOption)option parameter:(BKSearchParameter *)parameter completeHandler:(loadDataComplete)completeHandler {
    [[BKAPIManager sharedBKAPIManager] loadData:option parameter:parameter completeHandler:^(NSArray *shopIDs, NSArray *rawDatas) {
        self.shopIDs = shopIDs;
        [self addShopInfosWithRawDatas:rawDatas forShopIDs:shopIDs];
        completeHandler(YES);
    }];
}

- (void)loadShopDetailDataShopID:(NSString *)shopID completeHandler:(loadDataComplete)completeHandler {
    [[BKAPIManager sharedBKAPIManager] shopDetailWithShopID:shopID completionHandler:^(id data, NSError *error) {
        
        NSLog(@"Shop detail:%@", data);
        if (data) {
            [self addShopInfoWithRawData:data forShopID:shopID];
            completeHandler(YES);
        }
        else {
            completeHandler(NO);
        }
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
        BKShopInfoForUser *newShopInfo = [[BKShopInfoForUser alloc] initWithData:rawData];
        newShopInfo.sShopID = shopID;
        [self.shopInfoDictionary setObject:newShopInfo forKey:shopID];
    }
    else {
        BKShopInfoForUser *oldShopInfo = [self.shopInfoDictionary objectForKey:shopID];
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

- (void)downloadImageForShopInfo:(BKShopInfoForUser *)shopInfo completeHandler:(void (^)(UIImage *))completeHandler {
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

- (BOOL)isDownloadingImageForShopInfo:(BKShopInfoForUser *)shopInfo {
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

@implementation BKShopInfoManager (Map)

- (NSArray *)annotations {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *theShopID in self.shopIDs) {
        [result addObject:[self shopInfoForShopID:theShopID]];
    }
    return [NSArray arrayWithArray:result];
}

@end

@implementation BKShopInfoManager (UserFavorite)

- (void)loadUserFavoriteShopsParameter:(BKSearchParameter *)parameter completeHandler:(loadUserFavCompleteHandler)completeHandler {
    [[BKAPIManager sharedBKAPIManager] loadData:BKSearchOptionUserFavorite parameter:parameter completeHandler:^(NSArray *shopIDs, NSArray *rawDatas) {
        [self addShopInfosWithRawDatas:rawDatas forShopIDs:shopIDs];
        //NSLog(@"33333 :%@", self.shopInfoDictionary);
        NSArray *shopInfos = [self shopInfosForShopIDs:shopIDs];
        //NSLog(@"22222 :%@", shopInfos);
        NSLog(@"RawData:%@", rawDatas);
        completeHandler(shopInfos);
    }];
}

@end
