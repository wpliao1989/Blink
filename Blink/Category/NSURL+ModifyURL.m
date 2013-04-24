//
//  NSURL+ModifyURL.m
//  Blink
//
//  Created by 維平 廖 on 13/4/23.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSURL+ModifyURL.h"

@implementation NSURL (ModifyURL)

- (NSURL *)URLByChangingSchemeTo:(NSString *)scheme {
    
    NSURL *result = self;
    NSString *absoluteString = [result absoluteString];
    if (result.scheme == nil) {
        absoluteString = [NSString stringWithFormat:@"%@%@", scheme, absoluteString];
        result = [NSURL URLWithString:absoluteString];
    }
    else {
        NSRange schemeRange = [absoluteString rangeOfString:result.scheme];
        absoluteString = [absoluteString stringByReplacingCharactersInRange:schemeRange withString:scheme];
        result = [NSURL URLWithString:absoluteString];
    }
    NSLog(@"New url:%@", result);
    return result;
}

@end
