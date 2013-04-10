//
//  BKSearchParameter.m
//  Blink
//
//  Created by 維平 廖 on 13/4/8.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKSearchParameter.h"

@implementation BKSearchParameter

- (NSString *)description {
    return [NSString stringWithFormat:@"offset:%@ qNum:%@ method:%@ city:%@ district:%@", [self.offset stringValue], [self.qNum stringValue], self.method, self.city, self.district];
}

@end
