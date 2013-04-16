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

@end
