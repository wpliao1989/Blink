//
//  BKShopInfoManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

FOUNDATION_EXPORT NSString *const BKShopImageDidDownloadNotification;
FOUNDATION_EXPORT NSString *const kBKShopImageDidDownloadUserInfoShopInfo;

typedef void (^loadDataComplete)();

@class BKShopInfo;

@interface BKShopInfoManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKShopInfoManager)

- (NSUInteger)shopCount;
- (NSString *)shopNameAtIndex:(NSUInteger)index;
- (NSString *)shopIDAtIndex:(NSUInteger)index;
- (BKShopInfo *)shopInfoAtIndex:(NSUInteger)index;
- (BKShopInfo *)shopInfoForShopID:(NSString *)shopID;

// Methods for loading new datas
- (void)loadDataWithListCriteria:(NSInteger)criteria completeHandler:(loadDataComplete)completeHandler;
- (void)loadDataWithSortCriteria:(NSInteger)criteria completeHandler:(loadDataComplete)completeHandler;
- (void)loadShopDetailDataShopID:(NSString *)shopID completeHandler:(loadDataComplete)completeHandler;

// Use this method to change current displaying shops in shoplist view controller
- (void)updateShopIDs:(NSArray *)shopIDs;

- (void)addShopInfoWithRawData:(id)rawData forShopID:(NSString *)shopID;
- (void)addShopInfosWithRawDatas:(NSArray *)rawDatas forShopIDs:(NSArray *)shopIDs; // This method is for updating multiple shopinfos at once

- (void)clearShopIDs;

// Shop image download
- (void)downloadImageForShopInfo:(BKShopInfo *)shopInfo completeHandler:(void (^)(UIImage *image))completeHandler;
- (BOOL)isDownloadingImageForShopInfo:(BKShopInfo *)shopInfo;

- (void)printShopIDs;

//- (void)addShopInfoWithRawData:(id)rawData;


@end
