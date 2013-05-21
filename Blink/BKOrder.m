//
//  BKOrder.m
//  
//
//  Created by 維平 廖 on 13/4/11.
//
//

#import "BKOrder.h"
#import "BKOrderContent.h"

NSString *const kBKOrderMethodDelivery = @"0";
NSString *const kBKOrderMethodTakeout = @"1";

@implementation BKOrder

@synthesize note = _note;

- (NSString *)note {
    if (_note == nil) {
        _note = @"";
    }
    return _note;
}

- (NSUInteger)numberOfOrderContents {
    return self.content.count;
}

- (BKOrderContent *)orderContentAtIndex:(NSInteger)index {
    return [self.content objectAtIndex:index];
}

- (NSString *)description {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[NSString stringWithFormat:@"name:%@", self.name]];
    [result addObject:[NSString stringWithFormat:@"recordTime:%@", self.recordTime]];
    [result addObject:[NSString stringWithFormat:@"phone:%@", self.phone]];
    [result addObject:[NSString stringWithFormat:@"address:%@", self.address]];
    [result addObject:[NSString stringWithFormat:@"note:%@", self.note]];
    [result addObject:[NSString stringWithFormat:@"content:%@", self.content]];
    [result addObject:[NSString stringWithFormat:@"totalPrice:%@", self.totalPrice]];
    [result addObject:[NSString stringWithFormat:@"shopName:%@", self.shopName]];
    
    return [result componentsJoinedByString:@"\n\t"];
}

@end
