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

- (void)addUserFavoriteShopID:(NSString *)shopID completeHandler:(completeHandler)completeHandler {
    if (self.userToken == nil) {
        completeHandler(NO);
    }
    else {
        [[BKAPIManager sharedBKAPIManager] addUserFavoriteWithToken:self.userToken sShopID:shopID completeHandler:^(id data, NSError *error) {
            
            [self getUserFavoriteShopsCompleteHandler:^(BOOL success) {
                completeHandler(success);
            }];
            
            //self.userFavoriteShops = nil;
            //completeHandler(YES);
        }];
    }
}

- (void)deleteUserFavoriteShopID:(NSString *)shopID completeHandler:(completeHandler)completeHandler {
    if (self.userToken == nil) {
        completeHandler(NO);
    }
    else {
        [[BKAPIManager sharedBKAPIManager] deleteUserFavoriteWithToken:self.userToken sShopID:shopID completeHandler:^(id data, NSError *error) {
            
            [self getUserFavoriteShopsCompleteHandler:^(BOOL success) {
                completeHandler(success);
            }];
            
            //self.userFavoriteShops = nil;
            //completeHandler(YES);
        }];
    }
}

@end
