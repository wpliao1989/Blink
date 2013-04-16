//
//  NSMutableArray+Sort.h
//  Blink
//
//  Created by 維平 廖 on 13/4/2.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Sort)

// Sort using order in theArray
- (void)sortUsingAnotherArray:(NSArray *)theArray;

@end

@interface NSArray (Sort)

- (NSArray *)sortedArrayUsingArray:(NSArray *)theArray;
- (NSArray *)sortedArrayByNumberValue;

@end
