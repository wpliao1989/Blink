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

@property (nonatomic) BOOL isLogin;
// Array of shopInfos
@property (strong, nonatomic) NSArray *favoriteShops;

- (void)login;
- (void)logout;

@end
