//
//  BKShopInfo.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfoForUser.h"
#import "NSObject+NullObject.h"
#import "NSNumber+NullNumber.h"

NSString *const kBKShopID = @"shopID";
NSString *const kBKSShopID = @"sShopID";
//NSString *const kBKShopExternalID = @"extID";
//NSString *const kBKShopRegion = @"region";

@interface BKShopInfoForUser ()

@end

@implementation BKShopInfoForUser



@synthesize sShopID = _shopID;
//@synthesize externalID = _externalID;
//@synthesize region = _region;

//@synthesize managerName = _managerName;
//@synthesize managerPhone = _managerPhone;
//@synthesize managerEmail = _managerEmail;


#pragma mark - Shop basic infos

- (NSString *)sShopID {
    id object = self.data[kBKSShopID];
    if ([object isNullOrNil] || ![object isString]) {
        object = self.data[kBKShopID];
        if ([object isNullOrNilOrNotString]) {
            return BKShopInfoEmptyString;
        }        
    }
    return object;
}

- (NSNumber *)distance {
    id object = self.data[kBKShopDistance];
    if ([object isNullOrNil] || ![object isNumber]) {
        return [NSNumber nullNumber];
    }
    return object;
}

@end

@implementation BKShopInfoForUser (Map)

- (CLLocationCoordinate2D)coordinate {
    return self.shopLocaiton.coordinate;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return [self localizedTypeString];
}

@end
