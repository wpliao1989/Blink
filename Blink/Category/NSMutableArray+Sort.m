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
