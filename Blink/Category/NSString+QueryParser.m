//
//  NSString+QueryParser.m
//  Jingo
//
//  Created by Wei Ping on 13/3/20.
//
//

#import "NSString+QueryParser.h"

@implementation NSString (QueryParser)

- (NSDictionary *)queryDictionary {
    NSString *query = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return [[NSDictionary alloc] initWithDictionary:dict];
}

@end
