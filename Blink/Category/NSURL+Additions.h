//
//  NSURL+Additions.h
//  Blink
//
//  Created by 維平 廖 on 13/4/26.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Additions)

+ (NSURL *)smartURLForString:(NSString *)str;

- (NSURL *)URLByChangingSchemeTo:(NSString *)scheme;

@end
