//
//  BKOrder.m
//  
//
//  Created by 維平 廖 on 13/4/11.
//
//

#import "BKOrder.h"
#import "BKOrderContent.h"

@implementation BKOrder

- (NSUInteger)numberOfOrderContents {
    return self.content.count;
}

- (BKOrderContent *)orderContentAtIndex:(NSInteger)index {
    return [self.content objectAtIndex:index];
}

@end
