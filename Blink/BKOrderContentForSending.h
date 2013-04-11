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

@class BKMenuItem;

@interface BKOrderContentForSending : NSObject

- initWithMenu:(BKMenuItem *)menu ice:(NSString *)ice sweetness:(NSString *)sweetness quantity:(NSNumber *)quantity size:(NSString *)size;

//@property (strong, nonatomic) NSNumber *UUID;
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *ice;
@property (strong, nonatomic) NSString *sweetness;
@property (strong, nonatomic) NSNumber *quantity;

// These two properties are not required by API, but will be shown on screen for user
//@property (strong, nonatomic) NSString *basePrice;
@property (strong, nonatomic) NSNumber *basePrice;
//@property (strong, nonatomic) NSString *price;

- (NSNumber *)priceValue;

- (NSDictionary *)contentForAPI;
- (BOOL)isEqualExceptQuantity:(BKOrderContentForSending *)theOrderContent;

- (void)printValuesOfProperties;

@end

@interface BKOrderContentForSending (Localization)

- (NSString *)localizedSize;

@end
