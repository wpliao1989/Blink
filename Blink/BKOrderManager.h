//
//  BKOrderManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/18.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@interface BKOrderManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKOrderManager)

@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSDate *recordTime;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
//
@property (nonatomic, strong) NSMutableArray *content;
//
@property (nonatomic, strong) NSString *note;

- (BOOL)isValidOrder;
- (void)sendOrder;

@end
