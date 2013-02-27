//
//  accountManager.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAccountManager.h"
#import "BKAPIManager.h"
#import "BKShopInfoManager.h"

#import "BKTestCenter.h"

@implementation BKAccountManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAccountManager)

@synthesize isLogin = _isLogin;
@synthesize favoriteShopIDs = _favoriteShops;
@synthesize userToken = _userToken;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;
@synthesize userPhone = _userPhone;

//- (NSArray *)favoriteShopIDs {
//    if (_favoriteShops == nil) {
//#warning Test favorite shop infos
//        _favoriteShops = [BKTestCenter testFavoriteShopInfos];
//    }
//    return _favoriteShops;
//}

- (id)init {   
    self = [super init];
    if (self) {       
        _isLogin = NO;
    }
    return self;
}

- (void)login {
    // fetch user personal info
    self.userToken = @"123";
    self.userName = @"Flyingman";
    self.userEmail = @"flyingman@fly.com.tw";
    self.userPhone = @"987654321";
    // fetch user favorite shop IDs
    self.favoriteShopIDs = @[@"01", @"02", @"03"];
    NSArray *testFavShops = [BKTestCenter testFavoriteShops];
    for (int i = 0; i < self.favoriteShopIDs.count; i++) {
        [[BKShopInfoManager sharedBKShopInfoManager] addShopInfoWithRawData:[testFavShops objectAtIndex:i] forShopID:[self.favoriteShopIDs objectAtIndex:i]];
    }
    
    // fetch user order history
    
    // change isLogin flag
    self.isLogin = YES;
}

- (void)logout {
    self.isLogin = NO;
}

@end
