//
//  BKShopInfo.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKShopInfo : NSObject

- (id)initWithName:(NSString *)shopName;

@property (strong, nonatomic) NSString *name;

@end
