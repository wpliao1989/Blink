//
//  BKOrderManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/18.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderManager.h"
#import "BKAccountManager.h"
#import "BKAPIManager.h"

#import "BKTestCenter.h"

NSString *const kBKOrderUserToken = @"userToken";
NSString *const kBKOrderShopID = @"sShopID";
NSString *const kBKOrderRecordTime = @"recordTime";
NSString *const kBKOrderUserAddress = @"address";
NSString *const kBKOrderUserPhone = @"phone";
NSString *const kBKOrderContent = @"content";

@interface BKOrderManager ()

@end

@implementation BKOrderManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKOrderManager)

- (BOOL)isValidOrder {
    return NO;
}

- (void)sendOrder {
    NSDictionary *testDict = [BKTestCenter testOrder];
    [[BKAPIManager sharedBKAPIManager] orderWithData:testDict completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        NSLog(@"%@", data);        
    }];   
}

@end
