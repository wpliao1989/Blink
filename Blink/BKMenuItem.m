//
//  BKMenuItem.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuItem.h"

NSString *const kBKMenuUUID = @"UUID";
NSString *const kBKMenuName = @"name";
NSString *const kBKMenuPrice = @"price";
NSString *const kBKMenuIce = @"ice";
NSString *const kBKMenuSweetness = @"sweetness";
NSString *const kBKMenuDetail = @"detail";

@interface BKMenuItem ()

@property (strong, nonatomic) NSDictionary *data;

@end

@implementation BKMenuItem

@synthesize UUID = _UUID;
@synthesize name = _name;
@synthesize price = _price;
@synthesize iceLevels = _iceLevels;
@synthesize sweetnessLevels = _sweetnessLevels;
@synthesize detail = _detail;

- (NSNumber *)UUID {
#warning UUID may need to be converted to NSNumber
    return [self.data objectForKey:kBKMenuUUID];
}

- (NSString *)name {
    return [self.data objectForKey:kBKMenuName];
}

- (NSDictionary *)price {
    return [self.data objectForKey:kBKMenuPrice];
}

- (NSArray *)iceLevels {
    return [self.data objectForKey:kBKMenuIce];
}

- (NSArray *)sweetnessLevels {
    return [self.data objectForKey:kBKMenuSweetness];
}

- (NSString *)detail {
    return [self.data objectForKey:kBKMenuDetail];
}

- (id)initWithData:(NSDictionary *)data  {
    self = [super init];
    if (self) {
        self.data = data;
//        _UUID = [data objectForKey:kBKMenuUUID];
//        _name = [data objectForKey:kBKMenuName];
//        _price = [data objectForKey:kBKMenuPrice];
//        _iceLevels = [data objectForKey:kBKMenuIce];
//        _sweetnessLevels = [data objectForKey:kBKMenuSweetness];
//        _detail = [data objectForKey:kBKMenuDetail];
    }
    return self;
}

@end
