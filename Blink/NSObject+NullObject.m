//
//  NSObject+NullObject.m
//  Blink
//
//  Created by 維平 廖 on 13/4/1.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSObject+NullObject.h"

@implementation NSObject (NullObject)

- (BOOL)isNullOrNil {
    return (self == [NSNull null] || self == nil);
}

- (BOOL)isString {
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)isNumber {
    return [self isKindOfClass:[NSNumber class]];
}

@end
