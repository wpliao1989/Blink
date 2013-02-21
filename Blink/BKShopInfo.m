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
    }
    return self;
}

@end
