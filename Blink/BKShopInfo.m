//
//  BKShopInfo.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfo.h"

@implementation BKShopInfo

@synthesize name = _name;

- (id)initWithName:(NSString *)shopName {
    self = [super init];
    if (self) {
        self.name = shopName;
    }
    return self;
}

@end
