//
//  accountManager.h
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

FOUNDATION_EXPORT NSString *const BKConnecting;
FOUNDATION_EXPORT NSString *const BKLoginSuccess;
//FOUNDATION_EXPORT NSString *const kBKLoginFailed;

@interface BKAccountManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKAccountManager)

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;

@property (strong, nonatomic) NSString *userPreferedAccount;
@property (strong, nonatomic) NSString *userPreferedPassword;
@property (nonatomic) BOOL isSavingPreferences;

- (void)saveUserPreferedAccount:(NSString *)account password:(NSString *)password;

@property (nonatomic) BOOL isLogin;
// Array of shopInfos
@property (strong, nonatomic) NSArray *favoriteShopIDs;

- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd CompleteHandler:(void (^)(BOOL success, NSError *error))completeHandler;
- (void)logout;

@end
