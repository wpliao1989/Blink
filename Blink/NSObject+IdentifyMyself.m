//
//  NSObject+IdentifyMyself.m
//  Blink
//
//  Created by 維平 廖 on 13/4/2.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSObject+IdentifyMyself.h"

@implementation NSObject (IdentifyMyself)

- (void)identifyMyself {
    NSLog(@"Object is %@, class %@", self, [self class]);
}

- (void)identifyMyselfWithPrefix:(NSString *)prefix suffix:(NSString *)suffix seperator:(NSString *)seperator {
    NSMutableArray *array = [NSMutableArray array];
    NSString *body = [NSString stringWithFormat:@"Object is %@, class %@", self, [self class]];
    NSString *sp = seperator == nil ? @"" : seperator;
    
    NSLog(@"prefix:%@", prefix);
    if (prefix != nil) {
        [array addObject:prefix];
    }
    [array addObject:body];
    if (suffix != nil) {
        [array addObject:suffix];
    }
    
    NSLog(@"%@", [array componentsJoinedByString:sp]);
}

@end
