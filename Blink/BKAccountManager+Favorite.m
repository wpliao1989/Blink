//
//  BKAccountManager+Favorite.m
//  Blink
//
//  Created by 維平 廖 on 13/4/12.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAccountManager+Favorite.h"
#import "BKAPIManager.h"

@implementation BKAccountManager (Favorite)

- (void)addUserFavoriteShopID:(NSString *)shopID completeHandler:(loadDataComplete)completeHandler {
    if (self.userToken == nil) {
        completeHandler(NO);
    }
    else {
        [[BKAPIManager sharedBKAPIManager] addUserFavoriteWithToken:self.userToken sShopID:shopID completeHandler:^(id data, NSError *error) {
            self.userFavoriteShops = nil;
            completeHandler(YES);
        }];
    }
}

@end
