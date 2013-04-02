//
//  BKMenuItem.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuItem.h"
#import "NSObject+NullObject.h"
#import "NSObject+IdentifyMyself.m"
#import "NSMutableArray+Sort.h"

NSString *const kBKMenuUUID = @"UUID";
NSString *const kBKMenuName = @"name";
NSString *const kBKMenuPrice = @"price";
NSString *const kBKMenuIce = @"ice";
NSString *const kBKMenuSweetness = @"sweetness";
NSString *const kBKMenuDetail = @"detail";

NSString *const kBKMenuPriceMedium = @"Medium";
NSString *const kBKMenuPriceLarge = @"Large";
NSString *const kBKMenuPriceSmall = @"Small";

NSString *const BKMenuNullString = @"null";

@implementation BKMenuItem (Lookup)

+ (NSString *)localizedStringForIce:(NSString *)ice {
    id result = [[[self class] iceLookup] objectForKey:ice];
    if ([result isNullOrNil] || ![result isString]) {
        result = nil;
    }
    return result;
}

+ (NSString *)localizedStringForSweetness:(NSString *)sweetness {
    id result = [[[self class] sweetnessLookup] objectForKey:sweetness];
    if ([result isNullOrNil] || ![result isString]) {
        result = nil;
    }
    return result;
}

+ (NSDictionary *)iceLookup {
    static NSDictionary *result;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"IceDictionary" withExtension:@"plist"]];
    });
    //[result identifyMyself];
    return result;
}

+ (NSDictionary *)sweetnessLookup {
    static NSDictionary *result;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"SweetnessDictionary" withExtension:@"plist"]];
    });
    //[result identifyMyself];
    return result;
}

@end

@interface BKMenuItem ()

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) NSDictionary *price;

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
    id object = [self.data objectForKey:kBKMenuPrice];
    if ([object isNullOrNil] || ![object isDictionary]) {
        
        NSLog(@"Warning: price is %@ class:%@, not valid!", object, [object class]);
        
        NSDictionary *test = [NSJSONSerialization JSONObjectWithData:[(NSString *)[self.data objectForKey:kBKMenuPrice] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"test = %@", test);
        NSLog(@"test class = %@", [test class]);
        for (id obj in test.allValues) {
            NSLog(@"obj is %@, class %@", obj, [obj class]);
        }
        
        return test;
    }
    return object;
}

- (NSArray *)iceLevels {
    if (_iceLevels == nil) {
        id object = [self.data objectForKey:kBKMenuIce];
        if ([object isNullOrNil] || ![object isArray]) {
            NSLog(@"Warning: ice is %@, class %@", object, [object class]);
            _iceLevels = @[];
        }
        else {
            NSArray *validKeys = [[[self class] iceLookup] allKeys];
            NSMutableArray *result = [NSMutableArray array];
            for (NSString *obj in object) {
                if (!([validKeys indexOfObject:obj] == NSNotFound)) {
                    [result addObject:obj];
                }
            }
            _iceLevels = [NSArray arrayWithArray:result];
        }
    }    
    return _iceLevels;
}

- (NSArray *)localizedIceLevels {
    if (_localizedIceLevels == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *ice in self.iceLevels) {
            NSLog(@"ice : %@", ice);
            id object = [[[self class] iceLookup] objectForKey:ice];
            if (object == nil) {
                object = BKMenuNullString;
            }            
            [array addObject:object];
        }
        _localizedIceLevels = [NSArray arrayWithArray:array];
    }
    //[_localizedIceLevels identifyMyself];
    return _localizedIceLevels;
}

- (NSArray *)sweetnessLevels {
    if (_sweetnessLevels == nil) {
        id object = [self.data objectForKey:kBKMenuSweetness];
        if ([object isNullOrNil] || ![object isArray]) {
            NSLog(@"Warning: sweetness is %@, class %@", object, [object class]);
            _sweetnessLevels = @[];
        }
        else {
            NSArray *validKeys = [[[self class] sweetnessLookup] allKeys];
            NSMutableArray *result = [NSMutableArray array];
            for (NSString *obj in object) {
                if (!([validKeys indexOfObject:obj] == NSNotFound)) {
                    [result addObject:obj];
                }
            }
            _sweetnessLevels = [NSArray arrayWithArray:result];
        }
    }    
    return _sweetnessLevels;
}

- (NSArray *)localizedSweetnessLevels {
    if (_localizedSweetnessLevels == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *sweetness in self.sweetnessLevels) {
            NSLog(@"sweetness: %@", sweetness);
            id object = [[[self class] sweetnessLookup] objectForKey:sweetness];
            if (object == nil) {
                object = BKMenuNullString;
            }
            [array addObject:object];
        }
        _localizedSweetnessLevels = [NSArray arrayWithArray:array];
    }
    //[_localizedSweetnessLevels identifyMyself];
    return _localizedSweetnessLevels;
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
        NSArray *sortOrder = @[kBKMenuPriceMedium, kBKMenuPriceLarge, kBKMenuPriceSmall];
        NSMutableArray *allKeys = [[self.price allKeys] mutableCopy];
        [allKeys sortUsingAnotherArray:sortOrder];
//            if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
//                NSString *leftString = obj1;
//                NSString *rightString = obj2;
//                
//                if ([leftString isEqualToString:kBKMenuPriceMedium]) {
//                    NSLog(@"1");
//                    return NSOrderedAscending;
//                }
//                else if ([leftString isEqualToString:kBKMenuPriceLarge] && ![rightString isEqualToString:kBKMenuPriceMedium]) {
//                    NSLog(@"2");
//                    return NSOrderedAscending;
//                }
//                else if ([leftString isEqualToString:kBKMenuPriceSmall] && ![rightString isEqualToString:kBKMenuPriceMedium] && ![rightString isEqualToString:kBKMenuPriceLarge]) {
//                    NSLog(@"3");
//                    return NSOrderedAscending;
//                }
//            }
//            NSLog(@"obj1 = %@", obj1);
//            NSLog(@"obj2 = %@", obj2);            
//            NSLog(@"4");
//            return NSOrderedDescending;
        _sizeLevels = [NSArray arrayWithArray:allKeys];
    }
    return _sizeLevels;
}

- (NSNumber *)priceForSize:(NSString *)size {
    id result = [self.price objectForKey:size];
    if ([result isNullOrNil] || ![result isNumber]) {
        if ([result isString]) {
            static NSNumberFormatter *formatter;
            if (formatter == nil) {
                formatter = [[NSNumberFormatter alloc] init];
            }
            result = [formatter numberFromString:result];
            return result;
        }
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
