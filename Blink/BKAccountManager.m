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
#import "NSObject+NullObject.h"
#import "BKSearchParameter.h"
#import "BKOrderForReceiving.h"

#import "BKTestCenter.h"

NSString *const kBKUserEMail = @"email";
NSString *const kBKUserToken = @"token";
NSString *const kBKUserName = @"name";
NSString *const kBKUserAddress = @"address";
NSString *const kBKUserPhone = @"phone";

NSString *const kBKUserPreferedAccount = @"kBKUserPreferedAccount";
NSString *const kBKUserPreferedPassword = @"kBKUserPreferedPassword";
NSString *const kBKUserPreferedIsSaving = @"kBKUserPreferedIsSaving";

NSString *const BKLoggingMessage = @"登入中...";
NSString *const BKLoginSuccessMessage = @"登入成功!";
//NSString *const kBKErrorMessage = @"kBKErrorMessage";
//NSString *const kBKLoginFailed = @"Login failed...";

NSString *const emptyString = @"Null data";

@interface BKAccountManager ()

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSString *pwd;
- (void)clear;

@end

@implementation BKAccountManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAccountManager)

@synthesize isLogin = _isLogin;
@synthesize userToken = _userToken;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;
@synthesize userPhone = _userPhone;
@synthesize userAddress = _userAddress;
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

- (NSString *)userToken {
    id object = [self.data objectForKey:kBKUserToken];
    if ([object isNullOrNil] || ![object isString]) {
        return nil;
    }
    return object;
}

- (NSString *)userEmail {
    id object = [self.data objectForKey:kBKUserEMail];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;

}

- (NSString *)userName {
    id object = [self.data objectForKey:kBKUserName];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

- (NSString *)userPhone {
    id object = [self.data objectForKey:kBKUserPhone];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

- (NSString *)userAddress {
    id object = [self.data objectForKey:kBKUserAddress];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
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
            self.pwd = pwd;
            NSLog(@"Login success! Data:%@", data);
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
    [[BKAPIManager sharedBKAPIManager] logoutWithToken:self.userToken completeHandler:^(id data, NSError *error) {
        /*Do nothing*/
    }];
    self.isLogin = NO;
    [self clear];
}

- (void)clear {
    self.data = nil;
    self.pwd = nil;
    self.userFavoriteShops = nil;
    self.userOrderlist = nil;
}

@end

@implementation BKAccountManager (UserTool)

- (void)getUserFavoriteShopsCompleteHandler:(loadDataComplete)completeHandler {
    BKSearchParameter *parameter = [[BKSearchParameter alloc] init];
    parameter.token = self.userToken;
    [[BKShopInfoManager sharedBKShopInfoManager] loadUserFavoriteShopsParameter:parameter completeHandler:^(NSArray *shopInfos) {        
        self.userFavoriteShops = shopInfos;
        NSLog(@"Shop info!!   %@", self.userFavoriteShops);
        completeHandler(YES);
    }];
}

- (void)getUserOrdersCompleteHandler:(loadDataComplete)completeHandler {
    [[BKAPIManager sharedBKAPIManager] getOrderWithToken:self.userToken completionHandler:^(id data, NSError *error) {
        //NSLog(@"data = %@", data);
        if (data != nil) {
            NSString *kOrderList = @"orderList"; // For getting order list return from API
            data = [data objectForKey:kOrderList];
            
            //NSLog(@"new orders data: %@", data);
            NSMutableArray *result = [NSMutableArray array];
            for (NSDictionary *rawData in data) {
                BKOrderForReceiving *theItem = [[BKOrderForReceiving alloc] initWithData:rawData];
                //[theItem testPrint];
                [result addObject:theItem];
            }
            self.userOrderlist = [NSArray arrayWithArray:result];
            completeHandler(YES);
        }
        else {
            completeHandler(NO);
        }
        
    }];
}

- (void)editUserName:(NSString *)name address:(NSString *)address email:(NSString *)email phone:(NSString *)phone completionHandler:(void (^)(BOOL, NSError *))completeHandler {
    [[BKAPIManager sharedBKAPIManager] editUserName:name address:address email:email phone:phone token:self.userToken completionHandler:^(id data, NSError *error) {
        if (data != nil) {
            NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:self.data];
            [newData setObject:name forKey:kBKUserName];
            [newData setObject:address forKey:kBKUserAddress];
            [newData setObject:email forKey:kBKUserEMail];
            [newData setObject:phone forKey:kBKUserPhone];
            self.data = [NSDictionary dictionaryWithDictionary:newData];
        }
        completeHandler(data != nil, error);
    }];
}

- (void)editUserPWD:(NSString *)password completionHandler:(void (^)(BOOL, NSError *))completeHandler {
    [[BKAPIManager sharedBKAPIManager] editUserPWD:password token:self.userToken completionHandler:^(id data, NSError *error) {
        completeHandler(data != nil, error);
    }];
}

- (BOOL)isPasswordMatch:(NSString *)password {
    NSLog(@"self.password = %@, compared to %@", self.pwd, password);
    return [password isEqualToString:self.pwd];
}

@end

