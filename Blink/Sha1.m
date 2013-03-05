//
//  Sha1.m
//  Blink
//
//  Created by Wei Ping on 13/3/5.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "Sha1.h"
#import "Base64.h"

@implementation Sha1

+ (NSString *)sha1:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];       
    }   
    
    return output;
}

+ (NSData *)dataUsingSha1:(NSString *)input {    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
//    printf("digest = %s\n", digest);
    
    NSData *output = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
//    NSLog(@"output = %@", output);
    
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {        
//        NSLog(@"%02x", digest[i]);        
//    }
//    
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
//        NSLog(@"%c", digest[i]);        
//    }
//    
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
//        NSLog(@"%d", digest[i]);
//    }
//    
//    NSMutableString* output2 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
//        [output2 appendFormat:@"%02x", digest[i]];
//    }
    
//    const char *test = [output2 cStringUsingEncoding:NSUTF8StringEncoding];
//    for(int i = 0; i < output2.length; i++) {
//        NSLog(@"%d", test[i]);
//    }
//    NSData *test2 = [[NSData alloc] initWithBytes:test length:output2.length];
//    NSLog(@"test2 = %@", test2);
    
//    const char *test = [output2 cStringUsingEncoding:NSUTF8StringEncoding];
//    int len = output2.length;
//    char xx[20];
//    
//    NSLog(@"len = %d", len);
//    
//    for(int i = 0; i < output2.length; i = i + 2) {
////        NSLog(@"%c", test[i]);
//        NSLog(@"%d", i);
//        NSLog(@"%d   %@",i, [output2 substringWithRange:NSMakeRange(i, 2)]);
//        NSScanner *scanner = [NSScanner scannerWithString:[output2 substringWithRange:NSMakeRange(i, 2)]];
//        unsigned int tt;
//        [scanner scanHexInt:&tt];
//        NSLog(@"%c", (char)tt);
//        
////        [test2 appendBytes:(char)tt length:1];
//        xx[i/2] = (char)tt;
//    }
////    NSLog(@"test2 = %@", test2);
//    NSLog(@"xx = %s", xx);
//    NSData *test2 = [NSData dataWithBytes:xx length:20];
//    NSLog(@"test2 = %@", test2);
    
    return output;
}

@end
