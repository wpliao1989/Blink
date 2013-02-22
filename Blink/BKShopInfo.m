//
//  BKShopInfo.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfo.h"

NSString *const kBKShopInfoName = @"name";
NSString *const kBKShopInfoMenu = @"menu";
NSString *const kBKShopPhone = @"phone";
NSString *const kBKShopAddress = @"address";
NSString *const kBKShopOpenHour = @"businessHours";

@implementation BKShopInfo

@synthesize name = _name;
@synthesize menu = _menu;

- (id)initWithName:(NSString *)shopName {
    self = [super init];
    if (self) {
        self.name = shopName;
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.name = [data objectForKey:kBKShopInfoName];
        self.menu = [data objectForKey:kBKShopInfoMenu];
        self.phone = [data objectForKey:kBKShopPhone];
        self.address = [data objectForKey:kBKShopAddress];
        self.openHours = [data objectForKey:kBKShopOpenHour];
    }
    return self;
}

@end
