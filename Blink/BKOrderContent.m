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

@end
