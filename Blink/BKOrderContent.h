//
//  BKOrderContent.h
//  Blink
//
//  Created by 維平 廖 on 13/4/11.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKOrderContentUUID;
FOUNDATION_EXPORT NSString *const kBKOrderContentName;
FOUNDATION_EXPORT NSString *const kBKOrderContentSize;
FOUNDATION_EXPORT NSString *const kBKOrderContentIce;
FOUNDATION_EXPORT NSString *const kBKOrderContentSweetness;
FOUNDATION_EXPORT NSString *const kBKOrderContentQuantity;
FOUNDATION_EXPORT NSString *const kBKOrderContentPrice;

@interface BKOrderContent : NSObject

@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *ice;
@property (strong, nonatomic) NSString *sweetness;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSNumber *basePrice;

- (NSNumber *)priceValue;

- (void)printValuesOfProperties;

@end

@interface BKOrderContent (Localization)

- (NSString *)localizedIce;
- (NSString *)localizedSweetness;
- (NSString *)localizedSize;

@end
