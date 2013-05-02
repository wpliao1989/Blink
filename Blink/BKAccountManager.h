//
//  accountManager.h
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "BKAPIError.h"

@interface BKAccountManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKAccountManager)

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;

@property (strong, nonatomic) NSString *userPreferedAccount;
@property (strong, nonatomic) NSString *userPreferedPassword;
@property (nonatomic) BOOL isSavingPreferences;

@property (strong, nonatomic) NSArray *userFavoriteShops;
@property (strong, nonatomic) NSArray *userOrderlist;

- (void)saveUserPreferedAccount:(NSString *)account password:(NSString *)password;

@property (nonatomic) BOOL isLogin;

- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd CompleteHandler:(void (^)(BOOL success, NSError *error))completeHandler;
- (void)logout;

@end

@class BKShopInfo;

@interface BKAccountManager (UserTool)

- (void)getUserFavoriteShopsCompleteHandler:(completeHandler)completeHandler;
- (void)getUserOrdersCompleteHandler:(completeHandler)completeHandler;
- (void)editUserName:(NSString *)name address:(NSString *)address email:(NSString *)email phone:(NSString *)phone completionHandler:(void (^)(BOOL success, NSError *error))completeHandler;
- (void)editUserPWD:(NSString *)password completionHandler:(void (^)(BOOL success, NSError *error))completeHandler;
- (BOOL)isPasswordMatch:(NSString *)password;
- (BOOL)isUserFavoriteShop:(BKShopInfo *)shopInfo;

@end

