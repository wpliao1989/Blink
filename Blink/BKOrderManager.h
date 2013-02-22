//
//  BKOrderManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/18.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@class BKOrder;

@interface BKOrderManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKOrderManager)

@property (nonatomic, strong) BKOrder *order;

- (BOOL)isValidOrder;
- (void)sendOrder;

@end
