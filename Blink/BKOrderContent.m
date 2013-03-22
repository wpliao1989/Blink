//
//  BKOrder.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderContent.h"
#import "BKMenuItem.h"

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
//@synthesize price = _price;

- (id)initWithMenu:(BKMenuItem *)menu ice:(NSString *)ice sweetness:(NSString *)sweetness quantity:(NSNumber *)quantity size:(NSString *)size{
    self = [super init];
    if (self) {
        self.UUID = menu.UUID;
        self.name = menu.name;
        self.ice = ice;
        self.sweetness = sweetness;
        self.quantity = quantity;
        self.size = size;
        self.basePrice = [menu priceForSize:size];
    }
    return self;
}

//- (NSString *)basePrice {
//    if (_basePrice == nil) {
//        _basePrice = [[NSNumber numberWithDouble:0.0] stringValue];
//    }
//    return _basePrice;
//}

- (NSNumber *)basePrice {
    if (_basePrice == nil) {
        _basePrice = [NSNumber numberWithDouble:0.0];
    }
    return _basePrice;
}

- (NSDictionary *)contentForAPI {
    NSDictionary *theContent = @{kBKOrderContentUUID: self.UUID != nil ? self.UUID : @"none",
                                 kBKOrderContentName: self.name != nil ? self.name : @"none",
                                 kBKOrderContentSize: self.size != nil ? self.size : @"none",
                                 kBKOrderContentIce: self.ice != nil ? self.ice : @"none",
                                 kBKOrderContentSweetness: self.sweetness != nil ? self.sweetness : @"none",
                                 kBKOrderContentQuantity: self.quantity != nil ? self. quantity : @0};
    return theContent;
}

//- (NSString *)price {
//    static NSNumberFormatter *currencyFormatter;    
//    
//    if (currencyFormatter == nil) {
//        currencyFormatter = [[NSNumberFormatter alloc] init];
//        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        [currencyFormatter setPositiveFormat:@"¤#,###"];
//        NSLocale *twLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"];
//        [currencyFormatter setLocale:twLocale];
//        [currencyFormatter setCurrencySymbol:@"$"];
////        NSLog(@"positive format: %@", [currencyFormatter positiveFormat]);
//    }
//    
//    NSNumber *price = [self priceValue];
//   
////    NSLog(@"basePrice string is %@", self.basePrice);    
////    NSLog(@"price is %@", price);
////    NSLog(@"currency symbol is %@", [currencyFormatter currencySymbol]);
//    
//    return [currencyFormatter stringFromNumber:price];
//}

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

- (BOOL)isEqualExceptQuantity:(BKOrderContent *)theOrderContent {
//    NSLog([self.UUID isEqualToNumber:theOrderContent.UUID]?@"YES":@"NO");
//    NSLog([self.name isEqualToString:theOrderContent.name]?@"YES":@"NO");
//    NSLog(([self.ice isEqualToString:theOrderContent.ice]) || ((self.ice == nil) && (theOrderContent.ice == nil))?@"YES":@"NO");
//    NSLog(([self.sweetness isEqualToString:theOrderContent.sweetness]) || ((self.sweetness == nil) && (theOrderContent.sweetness == nil))?@"YES":@"NO");    
    
    if (theOrderContent.UUID == nil) {
        return NO;
    }
    
    if (([self.UUID isEqualToString:theOrderContent.UUID]) &&
        ([self.name isEqualToString:theOrderContent.name]) &&
        (([self.ice isEqualToString:theOrderContent.ice]) || ((self.ice == nil) && (theOrderContent.ice == nil))) &&
        (([self.sweetness isEqualToString:theOrderContent.sweetness]) || ((self.sweetness == nil) && (theOrderContent.sweetness == nil))) &&
        ([self.size isEqualToString:theOrderContent.size])) {
        return YES;
    }
    return NO;
}

- (void)printValuesOfProperties {
    NSLog(@"UUID is: %@", self.UUID);
    NSLog(@"name is: %@", self.name);
    NSLog(@"size is: %@", self.size);
    NSLog(@"ice is: %@", self.ice);
    NSLog(@"sweetness is: %@", self.sweetness);
    NSLog(@"quantity is: %@", self.quantity);
    NSLog(@"basePrice is: %@", self.basePrice);
//    NSLog(@"price is: %@", self.price);
}

@end
