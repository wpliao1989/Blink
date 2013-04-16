//
//  BKMenuItem.m
//  
//
//  Created by 維平 廖 on 13/4/16.
//
//

#import "BKMenuItem.h"
#import "BKLookup.h"
#import "NSObject+NullObject.h"
#import "NSMutableArray+Sort.h"

NSString *const kBKMenuName = @"name";
NSString *const kBKMenuPrice = @"price";
NSString *const kBKMenuIce = @"ice";
NSString *const kBKMenuSweetness = @"sweetness";
NSString *const kBKMenuDetail = @"detail";

@implementation BKMenuItem

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

+ (id)menuItemForMenuItem:(BKMenuItem *)item {
    BKMenuItem *result = [[BKMenuItem alloc] init];
    result.name = item.name;
    result.iceLevels = item.iceLevels;
    result.sweetnessLevels = item.sweetnessLevels;
    result.sizeLevels = item.sizeLevels;
    result.price = item.price;
    result.detail = item.detail;
    
    return result;
}

@end

@implementation BKMenuItem (Lookup)

+ (NSString *)localizedStringForIce:(NSString *)ice {
    return [BKLookup localizedStringForIce:ice];
}

+ (NSString *)localizedStringForSweetness:(NSString *)sweetness {
    return [BKLookup localizedStringForSweetness:sweetness];
}

+ (NSString *)localizedStringForSize:(NSString *)size {
    return [BKLookup localizedStringForSize:size];
}

+ (NSDictionary *)iceLookup {
    return [BKLookup iceLookup];
}

+ (NSDictionary *)sweetnessLookup {
    return [BKLookup sweetnessLookup];
}

+ (NSDictionary *)sizeLookup {
    return [BKLookup sizeLookup];
}

+ (NSArray *)orderedArrayOfIce {
    return [[BKLookup iceLookup].allKeys sortedArrayByNumberValue];
}

+ (NSArray *)orderedArrayOfSweetness {
    return [[BKLookup sweetnessLookup].allKeys sortedArrayByNumberValue];
}

+ (NSArray *)orderedArrayOfLocalizedIce {
    NSMutableArray *result = [NSMutableArray array];
    for (id unlocalizedIce in [BKMenuItem orderedArrayOfIce]) {
        [result addObject:[BKMenuItem localizedStringForIce:unlocalizedIce]];
    }
    return [NSArray arrayWithArray:result];
}

+ (NSArray *)orderedArrayOfLocalizedSweetness {
    NSMutableArray *result = [NSMutableArray array];
    for (id unlocalizedSweetness in [BKMenuItem orderedArrayOfSweetness]) {
        [result addObject:[BKMenuItem localizedStringForSweetness:unlocalizedSweetness]];
    }
    return [NSArray arrayWithArray:result];
}

@end
