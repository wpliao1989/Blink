//
//  Sha1.h
//  Blink
//
//  Created by Wei Ping on 13/3/5.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Sha1 : NSObject

+ (NSString *)sha1:(NSString *)input;
+ (NSData *)dataUsingSha1:(NSString *)input;

@end
