//
//  NSURL+ModifyURL.h
//  Blink
//
//  Created by 維平 廖 on 13/4/23.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ModifyURL)

- (NSURL *)URLByChangingSchemeTo:(NSString *)scheme;

@end
