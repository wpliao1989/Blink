//
//  BKMenuItem.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuItemForReceiving.h"
#import "NSObject+NullObject.h"
#import "NSObject+IdentifyMyself.h"
#import "NSMutableArray+Sort.h"
#import "BKLookup.h"

NSString *const kBKMenuUUID = @"UUID";
NSString *const kBKMenuPicURL = @"picture";

NSString *const kBKMenuPriceMedium = @"Medium";
NSString *const kBKMenuPriceLarge = @"Large";
NSString *const kBKMenuPriceSmall = @"Small";

NSString *const BKMenuNullString = @"null";

@interface BKMenuItemForReceiving ()

@property (strong, nonatomic) NSDictionary *data;

//@property (strong, nonatomic) NSDictionary *price;

- (NSArray *)arrayForKey:(NSString *)key validValues:(NSArray *)validValues;
- (NSArray *)localizedArrayForArray:(NSArray *)array lookup:(NSDictionary *)lookupTable;

@end

@implementation BKMenuItemForReceiving

@synthesize UUID = _UUID;
@synthesize name = _name;
@synthesize price = _price;
@synthesize iceLevels = _iceLevels;
@synthesize sweetnessLevels = _sweetnessLevels;
@synthesize localizedIceLevels = _localizedIceLevels;
@synthesize localizedSweetnessLevels = _localizedSweetnessLevels;
@synthesize localizedSizeLevels = _localizedSizeLevels;
@synthesize detail = _detail;
@synthesize picURL = _picURL;
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
        _iceLevels = [self arrayForKey:kBKMenuIce validValues:[[[self class] iceLookup] allKeys]];
    }    
    return _iceLevels;
}

- (NSArray *)sweetnessLevels {
    if (_sweetnessLevels == nil) {
        _sweetnessLevels = [self arrayForKey:kBKMenuSweetness validValues:[[[self class] sweetnessLookup] allKeys]];
    }
    return _sweetnessLevels;
}

- (NSArray *)sizeLevels {
    if (_sizeLevels == nil) {
        NSArray *sortOrder = @[kBKMenuPriceLarge, kBKMenuPriceMedium, kBKMenuPriceSmall];
        NSMutableArray *allKeys = [[self.price allKeys] mutableCopy];
        [allKeys sortUsingAnotherArray:sortOrder];
        _sizeLevels = [NSArray arrayWithArray:allKeys];
    }
    return _sizeLevels;
}

- (NSArray *)localizedIceLevels {
    if (_localizedIceLevels == nil) {
        _localizedIceLevels = [self localizedArrayForArray:self.iceLevels lookup:[[self class] iceLookup]];
    }
    //[_localizedIceLevels identifyMyself];
    return _localizedIceLevels;
}

- (NSArray *)localizedSweetnessLevels {
    if (_localizedSweetnessLevels == nil) {
        _localizedSweetnessLevels = [self localizedArrayForArray:self.sweetnessLevels lookup:[[self class] sweetnessLookup]];
    }
    //[_localizedSweetnessLevels identifyMyself];
    return _localizedSweetnessLevels;
}

- (NSArray *)localizedSizeLevels {
    if (_localizedSizeLevels == nil) {
        NSLog(@"!!!!!!!!!!!!!!!!");
        _localizedSizeLevels = [self localizedArrayForArray:self.sizeLevels lookup:[[self class] sizeLookup]];
        NSLog(@"localized size levels %@", _localizedSizeLevels);
        NSLog(@"!!!!!!!!!!!!!!!!");
    }
    //[_localizedSizeLevels identifyMyself];
    return _localizedSizeLevels;
}

- (NSArray *)arrayForKey:(NSString *)key validValues:(NSArray *)validValues {
    id object = [self.data objectForKey:key];
    if ([object isNullOrNil] || ![object isArray]) {
        return @[];
    }
    else {
        NSArray *validKeys = validValues;
        NSMutableArray *result = [NSMutableArray array];
        for (NSString *obj in object) {
            if (!([validKeys indexOfObject:obj] == NSNotFound)) {
                [result addObject:obj];
            }
        }
        return [NSArray arrayWithArray:result];
    }
}

- (NSArray *)localizedArrayForArray:(NSArray *)array lookup:(NSDictionary *)lookupTable {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *unlocalizedString in array) {
        id object = [lookupTable objectForKey:unlocalizedString];
        if (object == nil) {
            object = BKMenuNullString;
        }
        [result addObject:object];
    }
    return [NSArray arrayWithArray:result];
}

- (NSString *)detail {
    
    return [self.data objectForKey:kBKMenuDetail];
}

- (NSArray *)priceLevels {
    if (_priceLevels == nil) {
        NSMutableArray *thePriceLevels = [NSMutableArray array];
        for (NSString *size in self.sizeLevels) {
            [thePriceLevels addObject:[self.price objectForKey:size]];
            NSLog(@"size: %@ price: %@ class: %@", size, [self.price objectForKey:size], [[self.price objectForKey:size] class]);
        }        
        _priceLevels = [NSArray arrayWithArray:thePriceLevels];
    }
    return _priceLevels;
}

- (NSURL *)picURL {
    if (_picURL == nil) {
        id object = [self.data objectForKey:kBKMenuPicURL];
        if ([object isNullOrNil] || ![object isString]) {
            _picURL = nil;
        }
        else {
            _picURL = [NSURL URLWithString:object];
        }
    }
    return _picURL;
}

- (id)initWithData:(NSDictionary *)data  {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

@end
