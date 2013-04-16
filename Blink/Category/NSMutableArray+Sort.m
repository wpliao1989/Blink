//
//  NSMutableArray+Sort.m
//  Blink
//
//  Created by 維平 廖 on 13/4/2.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSMutableArray+Sort.h"

@implementation NSMutableArray (Sort)

- (void)sortUsingAnotherArray:(NSArray *)theArray {
    NSArray *sortOrder = theArray;
    
    [self sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger leftIndex = [sortOrder indexOfObject:obj1];
        NSUInteger rightIndex = [sortOrder indexOfObject:obj2];
        
        if (leftIndex < rightIndex) {
            //NSLog(@"1");
            return NSOrderedAscending;
        }
        else if (leftIndex > rightIndex) {
            //NSLog(@"2");
            return NSOrderedDescending;
        }
        else {
            //NSLog(@"3");
            return NSOrderedSame;
        }
    }];
}

@end

@implementation NSArray (Sort)

- (NSArray *)sortedArrayUsingArray:(NSArray *)theArray {
    NSMutableArray *result = [NSMutableArray arrayWithArray:self];
    [result sortedArrayUsingArray:theArray];
    return result;
}

- (NSArray *)sortedArrayByNumberValue {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    return [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[NSString class]]) {
            obj1 = [formatter numberFromString:obj1];
        }
        else if (![obj1 isKindOfClass:[NSNumber class]]) {
            return NSOrderedDescending;
        }
        
        if ([obj2 isKindOfClass:[NSString class]]) {
            obj2 = [formatter numberFromString:obj2];
        }
        else if ([obj2 isKindOfClass:[NSNumber class]]) {
            return NSOrderedAscending;
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            return NSOrderedAscending;
        }
        else if ([obj1 doubleValue] > [obj2 doubleValue]) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];
}

@end
