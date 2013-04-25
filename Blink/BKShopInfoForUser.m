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

@interface BKShopInfoForUser ()

@end

@implementation BKShopInfoForUser

#pragma mark - Shop basic infos

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
