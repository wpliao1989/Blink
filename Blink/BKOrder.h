//
//  BKOrder.h
//  
//
//  Created by 維平 廖 on 13/4/11.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKOrderMethodDelivery;
FOUNDATION_EXPORT NSString *const kBKOrderMethodTakeout;

@class BKOrderContent;

@interface BKOrder : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *recordTime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *method;
// Content is an array of BKOrderContent
@property (nonatomic, strong) NSArray *content;
@property (nonatomic, strong) NSNumber *totalPrice;

@property (nonatomic, strong) NSString *shopName;
- (NSUInteger)numberOfOrderContents;
- (BKOrderContent *)orderContentAtIndex:(NSInteger)index;

@end
