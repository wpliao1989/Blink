//
//  NSString+Additions.m
//  Blink
//
//  Created by 維平 廖 on 13/4/30.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)cleanString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)hasNoContent {
    return (self == nil) || ([self cleanString].length == 0);
}

@end
