//
//  NSString+MKCoordinateRegion.m
//  Blink
//
//  Created by 維平 廖 on 13/4/3.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "NSString+MKCoordinateRegion.h"

@implementation NSString (MKCoordinateRegion)

+ (NSString *)stringFromRegion:(MKCoordinateRegion)region {
    return [NSString stringWithFormat:@"Center:{lat:%f, lon:%f}, Span:{lat:%f, lon:%f}", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta];
}

@end
