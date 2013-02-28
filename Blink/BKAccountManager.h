//
//  accountManager.h
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@interface BKAccountManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKAccountManager)

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;

@property (nonatomic) BOOL isLogin;
// Array of shopInfos
@property (strong, nonatomic) NSArray *favoriteShopIDs;

- (void)loginWithCompleteHandler:(void (^)())completeHandler;
- (void)logout;

@end
