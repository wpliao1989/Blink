//
//  BKSearchParameter.h
//  Blink
//
//  Created by 維平 廖 on 13/4/8.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKSearchParameter : NSObject

/// For List and Sort
@property (nonatomic) NSInteger criteria;

/// For Search
@property (strong, nonatomic) NSString *shopName;

/// For User favorite shops
@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSNumber *offset;
@property (strong, nonatomic) NSNumber *qNum;
@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;

@end
