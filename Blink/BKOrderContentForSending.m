//
//  BKOrder.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderContentForSending.h"
#import "BKMenuItemForReceiving.h"

@implementation BKOrderContentForSending

@synthesize basePrice = _basePrice;
//@synthesize price = _price;

- (id)initWithMenu:(BKMenuItemForReceiving *)menu ice:(NSString *)ice sweetness:(NSString *)sweetness quantity:(NSNumber *)quantity size:(NSString *)size{
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

- (NSNumber *)basePrice {
    if (_basePrice == nil) {
        _basePrice = [NSNumber numberWithDouble:0.0];
    }
    return _basePrice;
}

- (NSDictionary *)contentForAPI {
    
    assert(self.UUID);
    assert(self.name);
    assert(self.size);
    assert(self.quantity);
    assert(self.basePrice);
    
    NSDictionary *theContent = @{kBKOrderContentUUID: self.UUID,
                                 kBKOrderContentName: self.name,
                                 kBKOrderContentSize: self.size,
                                 kBKOrderContentIce: self.ice != nil ? self.ice : [NSNull null],
                                 kBKOrderContentSweetness: self.sweetness != nil ? self.sweetness : [NSNull null],
                                 kBKOrderContentQuantity: self.quantity,
                                 kBKOrderContentPrice : self.basePrice,
                                 /*@"hello world!" : @"hello!"*/};
    return theContent;
}

- (BOOL)isEqualExceptQuantity:(BKOrderContentForSending *)theOrderContent {
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

@end
