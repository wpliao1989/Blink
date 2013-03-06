//
//  BKMenuItem.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKMenuUUID;
FOUNDATION_EXPORT NSString *const kBKMenuName;
FOUNDATION_EXPORT NSString *const kBKMenuPrice;
FOUNDATION_EXPORT NSString *const kBKMenuIce;
FOUNDATION_EXPORT NSString *const kBKMenuSweetness;
FOUNDATION_EXPORT NSString *const kBKMenuDetail;

@interface BKMenuItem : NSObject

- (id)initWithData:(NSDictionary *)data;

//@property (strong, nonatomic) NSNumber *UUID;
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *price;
@property (strong, nonatomic) NSArray *iceLevels;
@property (strong, nonatomic) NSArray *sweetnessLevels;
@property (strong, nonatomic) NSString *detail;

@property (strong, nonatomic) NSArray *priceLevels;
@property (strong, nonatomic) NSArray *sizeLevels;

- (NSNumber *)priceForSize:(NSString *)size;

@end
