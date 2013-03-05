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

NSString *const kBKUserEMail = @"email";
NSString *const kBKUserToken = @"token";
NSString *const kBKUserName = @"name";

static NSString *emptyString = @"Null data";

@interface BKAccountManager ()

@property (strong, nonatomic) NSDictionary *data;

@end

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

- (NSString *)userToken {
    if ([self.data objectForKey:kBKUserToken] == [NSNull null] || [self.data objectForKey:kBKUserToken] == nil) {
        return emptyString;
    }
    return [self.data objectForKey:kBKUserToken];
}

- (NSString *)userEmail {
    if ([self.data objectForKey:kBKUserEMail] == [NSNull null] || [self.data objectForKey:kBKUserEMail] == nil) {
        return emptyString;
    }
    return [self.data objectForKey:kBKUserEMail];
}

- (NSString *)userName {
    if ([self.data objectForKey:kBKUserName] == [NSNull null] || [self.data objectForKey:kBKUserName] == nil) {
        return emptyString;
    }
    return [self.data objectForKey:kBKUserName];
}

- (NSString *)userPhone {
    return @"987654321";
}

- (id)init {   
    self = [super init];
    if (self) {       
        _isLogin = NO;
    }
    return self;
}

- (void)loginWithCompleteHandler:(void (^)(BOOL))completeHandler {
    // fetch user personal info
    [[BKAPIManager sharedBKAPIManager] loginWithUserName:@"flyingman" password:@"fly123" completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        NSLog(@"login response: %@", data);
        
        if (data != nil) {
            self.data = data;            
            
            // fetch user favorite shop IDs
            //        self.favoriteShopIDs = @[@"4000", @"5000", @"6000"];
            //        NSArray *testFavShops = [BKTestCenter testFavoriteShops];
            //        for (int i = 0; i < self.favoriteShopIDs.count; i++) {
            //            [[BKShopInfoManager sharedBKShopInfoManager] addShopInfoWithRawData:[testFavShops objectAtIndex:i] forShopID:[self.favoriteShopIDs objectAtIndex:i]];
            //        }
            // fetch user order history
            
            self.isLogin = YES;
            completeHandler(YES);
        }
        
        else {
            completeHandler(NO);
        }        
    }];
}

- (void)logout {
    self.isLogin = NO;
}

@end
