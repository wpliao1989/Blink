//
//  BKShopInfo.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKShopInfoName;
FOUNDATION_EXPORT NSString *const kBKShopInfoMenu;

@interface BKShopInfo : NSObject

- (id)initWithName:(NSString *)shopName;
- (id)initWithData:(NSDictionary *)data;

@property (strong, nonatomic) NSString *name;
// Menu is an array of dictionaries(keys: UUID, name, price)
// value of price is a dictionary of size and actual price
@property (strong, nonatomic) NSArray *menu;

@end
