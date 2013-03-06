//
//  BKMenuItem.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuItem.h"

NSString *const kBKMenuUUID = @"UUID";
NSString *const kBKMenuName = @"name";
NSString *const kBKMenuPrice = @"price";
NSString *const kBKMenuIce = @"ice";
NSString *const kBKMenuSweetness = @"sweetness";
NSString *const kBKMenuDetail = @"detail";

NSString *const kBKMenuPriceMedium = @"Medium";
NSString *const kBKMenuPriceLarge = @"Large";
NSString *const kBKMenuPriceSmall = @"Small";

@interface BKMenuItem ()

@property (strong, nonatomic) NSDictionary *data;

@end

@implementation BKMenuItem

@synthesize UUID = _UUID;
@synthesize name = _name;
@synthesize price = _price;
@synthesize iceLevels = _iceLevels;
@synthesize sweetnessLevels = _sweetnessLevels;
@synthesize detail = _detail;

@synthesize priceLevels = _priceLevels;
@synthesize sizeLevels = _sizeLevels;

- (NSString *)UUID {
#warning UUID may need to be converted to NSNumber
    NSLog(@"UUID is %@", [self.data objectForKey:kBKMenuUUID]);
    NSLog(@"UUID class is %@", [[self.data objectForKey:kBKMenuUUID] class]);
    return [self.data objectForKey:kBKMenuUUID];
}

- (NSString *)name {
    return [self.data objectForKey:kBKMenuName];
}

- (NSDictionary *)price {
    if ([self.data objectForKey:kBKMenuPrice] == [NSNull null] || ![[self.data objectForKey:kBKMenuPrice] isKindOfClass:[NSDictionary class]]) {
        
        NSLog(@"Warning: price is %@ class:%@, not valid!", [self.data objectForKey:kBKMenuPrice], [[self.data objectForKey:kBKMenuPrice] class]);
        
        id test = [NSJSONSerialization JSONObjectWithData:[(NSString *)[self.data objectForKey:kBKMenuPrice] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"test = %@", test);
        NSLog(@"test class = %@", [test class]);
        
        return test;
    }
    return [self.data objectForKey:kBKMenuPrice];
}

- (NSArray *)iceLevels {
    if ([self.data objectForKey:kBKMenuIce] == [NSNull null] || ![[self.data objectForKey:kBKMenuIce] isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return [self.data objectForKey:kBKMenuIce];
}

- (NSArray *)sweetnessLevels {
    if ([self.data objectForKey:kBKMenuSweetness] == [NSNull null] || ![[self.data objectForKey:kBKMenuSweetness] isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return [self.data objectForKey:kBKMenuSweetness];
}

- (NSString *)detail {
    return [self.data objectForKey:kBKMenuDetail];
}

- (NSArray *)priceLevels {
    if (_priceLevels == nil) {
//        _priceLevels = @[@"20", @"30", @"10"];
        NSMutableArray *thePriceLevels = [NSMutableArray array];
        for (NSString *size in self.sizeLevels) {
            [thePriceLevels addObject:[self.price objectForKey:size]];
            NSLog(@"size: %@ price: %@ class: %@", size, [self.price objectForKey:size], [[self.price objectForKey:size] class]);
        }        
        _priceLevels = [NSArray arrayWithArray:thePriceLevels];
    }
    return _priceLevels;
}

- (NSArray *)sizeLevels {
    if (_sizeLevels == nil) {
//        _sizeLevels = @[@"正常", @"大", @"小"];
        NSMutableArray *allKeys = [[self.price allKeys] mutableCopy];
        [allKeys sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                NSString *leftString = obj1;
                NSString *rightString = obj2;
                
                if ([leftString isEqualToString:kBKMenuPriceMedium]) {
                    NSLog(@"1");
                    return NSOrderedAscending;
                }
                else if ([leftString isEqualToString:kBKMenuPriceLarge] && ![rightString isEqualToString:kBKMenuPriceMedium]) {
                    NSLog(@"2");
                    return NSOrderedAscending;
                }
                else if ([leftString isEqualToString:kBKMenuPriceSmall] && ![rightString isEqualToString:kBKMenuPriceMedium] && ![rightString isEqualToString:kBKMenuPriceLarge]) {
                    NSLog(@"3");
                    return NSOrderedAscending;
                }
            }
            NSLog(@"obj1 = %@", obj1);
            NSLog(@"obj2 = %@", obj2);            
            NSLog(@"4");
            return NSOrderedDescending;
        }];
        _sizeLevels = [NSArray arrayWithArray:allKeys];
    }
    return _sizeLevels;
}

- (NSNumber *)priceForSize:(NSString *)size {
    id result = [self.price objectForKey:size];
    if (![result isKindOfClass:[NSNumber class]] || result == nil) {
        return [NSNumber numberWithInt:0];
    }
    return result;
}

- (id)initWithData:(NSDictionary *)data  {
    self = [super init];
    if (self) {
        self.data = data;
//        _UUID = [data objectForKey:kBKMenuUUID];
//        _name = [data objectForKey:kBKMenuName];
//        _price = [data objectForKey:kBKMenuPrice];
//        _iceLevels = [data objectForKey:kBKMenuIce];
//        _sweetnessLevels = [data objectForKey:kBKMenuSweetness];
//        _detail = [data objectForKey:kBKMenuDetail];
    }
    return self;
}

@end
