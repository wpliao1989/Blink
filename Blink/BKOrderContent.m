//
//  BKOrderContent.m
//  Blink
//
//  Created by 維平 廖 on 13/4/11.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderContent.h"
#import "BKLookup.h"

NSString *const kBKOrderContentUUID = @"UUID";
NSString *const kBKOrderContentName = @"name";
NSString *const kBKOrderContentSize = @"size";
NSString *const kBKOrderContentIce = @"ice";
NSString *const kBKOrderContentSweetness = @"sweetness";
NSString *const kBKOrderContentQuantity = @"quantity";
NSString *const kBKOrderContentPrice = @"price";

@interface BKOrderContent ()

@end

@implementation BKOrderContent

- (NSNumber *)priceValue {
    //    static NSNumberFormatter *numberFormatter;
    //    if (numberFormatter == nil) {
    //        numberFormatter = [[NSNumberFormatter alloc] init];
    //        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //    }
    
    //    NSNumber *basePrice = [numberFormatter numberFromString:self.basePrice];
    NSNumber *basePrice = self.basePrice;
    //    if (basePrice == nil) {
    //        basePrice = [[NSNumber alloc] initWithDouble:0.0];
    //    }
    
    //    NSLog(@"basePrice is %@", basePrice);
    
    double bp = [basePrice doubleValue];
    double q = [self.quantity doubleValue];
    NSNumber *price = [NSNumber numberWithDouble:(bp*q)];
    return price;
}

- (NSString *)description {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[NSString stringWithFormat:@"UUID:%@", self.UUID]];
    [result addObject:[NSString stringWithFormat:@"name:%@", self.name]];
    [result addObject:[NSString stringWithFormat:@"size:%@", self.size]];
    [result addObject:[NSString stringWithFormat:@"ice:%@", self.ice]];
    [result addObject:[NSString stringWithFormat:@"sweetness:%@", self.sweetness]];
    [result addObject:[NSString stringWithFormat:@"quantity:%@", self.quantity]];
    [result addObject:[NSString stringWithFormat:@"basePrice:%@", self.basePrice]];
    
    return [result componentsJoinedByString:@", "];
}

@end

@implementation BKOrderContent (Localization)

- (NSString *)localizedIce {
    return [BKLookup localizedStringForIce:self.ice];
}

- (NSString *)localizedSweetness {
    return [BKLookup localizedStringForSweetness:self.sweetness];
}

- (NSString *)localizedSize {
    return [BKLookup localizedStringForSize:self.size];
}

@end