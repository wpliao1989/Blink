//
//  BKLookup.m
//  Blink
//
//  Created by 維平 廖 on 13/4/4.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKLookup.h"
#import "NSObject+NullObject.h"

@implementation BKLookup

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

+ (NSString *)localizedStringForSize:(NSString *)size {
    id result = [[[self class] sizeLookup] objectForKey:size];
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

+ (NSDictionary *)sizeLookup {
    static NSDictionary *result;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"SizeDictionary" withExtension:@"plist"]];
    });
    //[result identifyMyself];
    return result;
}

@end
