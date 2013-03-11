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

NSString *const kBKUserPreferedAccount = @"kBKUserPreferedAccount";
NSString *const kBKUserPreferedPassword = @"kBKUserPreferedPassword";
NSString *const kBKUserPreferedIsSaving = @"kBKUserPreferedIsSaving";

NSString *const BKLoggingMessage = @"登入中...";
NSString *const BKLoginSuccessMessage = @"登入成功!";
//NSString *const kBKLoginFailed = @"Login failed...";

NSString *const emptyString = @"Null data";

@interface BKAccountManager ()

@property (strong, nonatomic) NSDictionary *data;

- (BOOL)isNullValue:(id)object;
- (void)clear;

@end

@implementation BKAccountManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAccountManager)

@synthesize isLogin = _isLogin;
@synthesize favoriteShopIDs = _favoriteShops;
@synthesize userToken = _userToken;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;
@synthesize userPhone = _userPhone;
@synthesize userPreferedAccount = _userPreferedAccount;
@synthesize userPreferedPassword = _userPreferedPassword;
@synthesize isSavingPreferences = _isSavingPreferences;

//- (NSArray *)favoriteShopIDs {
//    if (_favoriteShops == nil) {
//#warning Test favorite shop infos
//        _favoriteShops = [BKTestCenter testFavoriteShopInfos];
//    }
//    return _favoriteShops;
//}

- (BOOL)isNullValue:(id)object {
    if (object == [NSNull null] || object == nil) {
        return YES;
    }
    return NO;
}

- (NSString *)userToken {
    if ([self isNullValue:[self.data objectForKey:kBKUserToken]]) {
        return emptyString;
    }
    return [self.data objectForKey:kBKUserToken];
}

- (NSString *)userEmail {
    if ([self isNullValue:[self.data objectForKey:kBKUserEMail]]) {
        return emptyString;
    }
    return [self.data objectForKey:kBKUserEMail];
}

- (NSString *)userName {
    if ([self isNullValue:[self.data objectForKey:kBKUserName]]) {
        return emptyString;
    }
    return [self.data objectForKey:kBKUserName];
}

- (NSString *)userPhone {
    return @"987654321";
}

- (void)setIsSavingPreferences:(BOOL)isSavingPreferences {
    _isSavingPreferences = isSavingPreferences;
    NSLog(isSavingPreferences? @"YES Saving" : @"NO Not Saving");
    [[NSUserDefaults standardUserDefaults] setBool:isSavingPreferences forKey:kBKUserPreferedIsSaving];
    if (isSavingPreferences == NO) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBKUserPreferedAccount];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBKUserPreferedPassword];
    }
//    NSLog([[NSUserDefaults standardUserDefaults] boolForKey:kBKUserPreferedIsSaving]? @"YES isSaving" : @"NO notSaving");
}

- (id)init {   
    self = [super init];
    if (self) {       
        _isLogin = NO;
        
        _isSavingPreferences = [[NSUserDefaults standardUserDefaults] boolForKey:kBKUserPreferedIsSaving];
        NSLog(_isSavingPreferences? @"YES isSaving" : @"NO notSaving");
        if (_isSavingPreferences) {
            _userPreferedAccount = [[NSUserDefaults standardUserDefaults] stringForKey:kBKUserPreferedAccount];
            _userPreferedPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kBKUserPreferedPassword];
        }        
    }
    return self;
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd CompleteHandler:(void (^)(BOOL, NSError *))completeHandler {
    // fetch user personal info   
    [[BKAPIManager sharedBKAPIManager] loginWithUserName:account password:pwd completionHandler:^(id data, NSError *error) {        
        if (data != nil) {
            self.data = data;            
            
            // fetch user favorite shop IDs
            //        self.favoriteShopIDs = @[@"4000", @"5000", @"6000"];
            //        NSArray *testFavShops = [BKTestCenter testFavoriteShops];
            //        for (int i = 0; i < self.favoriteShopIDs.count; i++) {
            //            [[BKShopInfoManager sharedBKShopInfoManager] addShopInfoWithRawData:[testFavShops objectAtIndex:i] forShopID:[self.favoriteShopIDs objectAtIndex:i]];
            //        }
            // fetch user order history
#warning check for correct result
            self.isLogin = YES;
            completeHandler(YES, error);
        }        
        else {
            completeHandler(NO, error);
        }        
    }];
}

- (void)saveUserPreferedAccount:(NSString *)account password:(NSString *)password {
    self.userPreferedAccount = account;
    self.userPreferedPassword = password;
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kBKUserPreferedAccount];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kBKUserPreferedPassword];
    self.isSavingPreferences = YES;
    
}

- (void)logout {
    self.isLogin = NO;
    [self clear];
}

- (void)clear {
    self.data = nil;    
}

@end
