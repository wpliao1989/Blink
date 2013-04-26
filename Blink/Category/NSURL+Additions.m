//
//  NSURL+Additions.m
//  Blink
//
//  Created by 維平 廖 on 13/4/26.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSURL+Additions.h"

@implementation NSURL (Additions)

+ (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

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
