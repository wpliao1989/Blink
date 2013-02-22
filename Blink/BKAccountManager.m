//
//  accountManager.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAccountManager.h"

#import "BKTestCenter.h"

@implementation BKAccountManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAccountManager)

@synthesize isLogin = _isLogin;
@synthesize favoriteShops = _favoriteShops;

- (NSArray *)favoriteShops {
    if (_favoriteShops == nil) {
#warning Test favorite shop infos
        _favoriteShops = [BKTestCenter testFavoriteShopInfos];
    }
    return _favoriteShops;
}

- (id)init {   
    self = [super init];
    if (self) {       
        _isLogin = NO;
    }
    return self;
}

- (void)login {
    // fetch user personal info
    // fetch user favorite shop IDs
    // fetch user order history
    
    // change isLogin flag
    self.isLogin = YES;
}

- (void)logout {
    self.isLogin = NO;
}

@end
