//
//  BKOrder.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKOrderUserToken;
FOUNDATION_EXPORT NSString *const kBKOrderShopID;
FOUNDATION_EXPORT NSString *const kBKOrderRecordTime;
FOUNDATION_EXPORT NSString *const kBKOrderUserAddress;
FOUNDATION_EXPORT NSString *const kBKOrderUserPhone;
FOUNDATION_EXPORT NSString *const kBKOrderContent;

@interface BKOrder : NSObject

@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *recordTime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;

// Content is an array of Dictionaries
@property (nonatomic, strong) NSArray *content;

@property (nonatomic, strong) NSString *note;

@end
