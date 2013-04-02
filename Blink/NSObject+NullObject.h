//
//  NSObject+NullObject.h
//  Blink
//
//  Created by 維平 廖 on 13/4/1.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NullObject)

- (BOOL)isNullOrNil;
- (BOOL)isString;
- (BOOL)isNumber;
- (BOOL)isArray;
- (BOOL)isDictionary;

@end
