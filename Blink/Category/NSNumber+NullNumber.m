//
//  NSNumber+NullNumber.m
//  Blink
//
//  Created by 維平 廖 on 13/4/12.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSNumber+NullNumber.h"

@implementation NSNumber (NullNumber)

+ (NSNumber *)nullNumber {
    return [NSNumber numberWithInt:-NSIntegerMax];
}

@end
