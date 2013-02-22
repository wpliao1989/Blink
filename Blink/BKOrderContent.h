//
//  BKOrder.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKOrderContentUUID;
FOUNDATION_EXPORT NSString *const kBKOrderContentName;
FOUNDATION_EXPORT NSString *const kBKOrderContentSize;
FOUNDATION_EXPORT NSString *const kBKOrderContentIce;
FOUNDATION_EXPORT NSString *const kBKOrderContentSweetness;
FOUNDATION_EXPORT NSString *const kBKOrderContentQuantity;

@interface BKOrderContent : NSObject

@property (nonatomic) NSInteger UUID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *ice;
@property (strong, nonatomic) NSString *sweetness;
@property (nonatomic) NSInteger quantity;

@end
