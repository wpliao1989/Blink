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

- (NSDictionary *)contentForAPI {
    NSDictionary *theContent = @{kBKOrderContentUUID: self.UUID != nil ? self.UUID : @0,
                                 kBKOrderContentName: self.name != nil ? self.name : @"none",
                                 kBKOrderContentSize: self.size != nil ? self.size : @"none",
                                 kBKOrderContentIce: self.ice != nil ? self.ice : @"none",
                                 kBKOrderContentSweetness: self.sweetness != nil ? self.sweetness : @"none",
                                 kBKOrderContentQuantity: self.quantity != nil ? self. quantity : @0};
    return theContent;
}

@end
