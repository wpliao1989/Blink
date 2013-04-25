//
//  BKAPIError.h
//  Blink
//
//  Created by Wei Ping on 13/3/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#ifndef Blink_BKAPIError_h
#define Blink_BKAPIError_h

FOUNDATION_EXPORT NSString *const BKErrorDomainNetwork;
FOUNDATION_EXPORT NSString *const BKErrorDomainWrongResult;
//FOUNDATION_EXPORT NSString *const BKErrorDomainWrongUserNameOrPassword;
//FOUNDATION_EXPORT NSString *const BKErrorDomainWrongOrder;
FOUNDATION_EXPORT NSString *const kBKErrorMessage;

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// Define wrong result codes
typedef NS_ENUM(NSUInteger, BKErrorWrongResult) {
    BKErrorWrongResultGeneral = 0,
    BKErrorWrongResultUserNameOrPassword = 1,
    BKErrorWrongResultOrder = 2
};

// For API complete handler
typedef void (^loadDataCompleteHandler)(NSArray *shopIDs, NSArray *rawDatas, NSString *key);
typedef void (^loadDataComplete)(BOOL success, NSString *key);
typedef void (^loadUserFavCompleteHandler)(NSArray *shopInfos);
typedef void (^completeHandler)(BOOL success);

#endif
