//
//  NSObject+IdentifyMyself.h
//  Blink
//
//  Created by 維平 廖 on 13/4/2.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IdentifyMyself)

- (void)identifyMyself;
- (void)identifyMyselfWithPrefix:(NSString *)prefix suffix:(NSString *)suffix seperator:(NSString *)seperator;

@end
