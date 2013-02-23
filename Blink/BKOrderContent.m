//
//  BKOrder.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderContent.h"

NSString *const kBKOrderContentUUID = @"UUID";
NSString *const kBKOrderContentName = @"name";
NSString *const kBKOrderContentSize = @"size";
NSString *const kBKOrderContentIce = @"ice";
NSString *const kBKOrderContentSweetness = @"sweetness";
NSString *const kBKOrderContentQuantity = @"quantity";

@implementation BKOrderContent

@synthesize UUID = _UUID;
@synthesize name = _name;
@synthesize size = _size;
@synthesize ice = _ice;
@synthesize sweetness = _sweetness;
@synthesize quantity = _quantity;

@synthesize basePrice = _basePrice;
@synthesize price = _price;

- (NSDictionary *)contentForAPI {
    NSDictionary *theContent = @{kBKOrderContentUUID: self.UUID != nil ? self.UUID : @0,
                                 kBKOrderContentName: self.name != nil ? self.name : @"none",
                                 kBKOrderContentSize: self.size != nil ? self.size : @"none",
                                 kBKOrderContentIce: self.ice != nil ? self.ice : @"none",
                                 kBKOrderContentSweetness: self.sweetness != nil ? self.sweetness : @"none",
                                 kBKOrderContentQuantity: self.quantity != nil ? self. quantity : @0};
    return theContent;
}

- (NSString *)price {
    static NSNumberFormatter *currencyFormatter;
    static NSNumberFormatter *numberFormatter;
    
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setPositiveFormat:@"¤#,###"];
        NSLocale *twLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"];
        [currencyFormatter setLocale:twLocale];
        [currencyFormatter setCurrencySymbol:@"$"];
        NSLog(@"positive format: %@", [currencyFormatter positiveFormat]);
    }
    
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];        
    }
    
    NSNumber *basePrice = [numberFormatter numberFromString:self.basePrice];
    if (basePrice == nil) {
        basePrice = [[NSDecimalNumber alloc] initWithDouble:0.0];
    }    
    
    double bp = [basePrice doubleValue];
    double q = [self.quantity doubleValue];
    NSNumber *price = [NSNumber numberWithDouble:(bp*q)];
   
    NSLog(@"basePrice string is %@", self.basePrice);
    NSLog(@"basePrice is %@", basePrice);
    NSLog(@"price is %@", price);
//    NSLog(@"currency symbol is %@", [currencyFormatter currencySymbol]);
    
    return [currencyFormatter stringFromNumber:price];
}

@end
