//
//  BKLookup.h
//  Blink
//
//  Created by 維平 廖 on 13/4/4.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKLookup : NSObject

+ (NSString *)localizedStringForIce:(NSString *)ice;
+ (NSString *)localizedStringForSweetness:(NSString *)sweetness;
+ (NSString *)localizedStringForSize:(NSString *)size;

+ (NSDictionary *)iceLookup;
+ (NSDictionary *)sweetnessLookup;
+ (NSDictionary *)sizeLookup;

@end
