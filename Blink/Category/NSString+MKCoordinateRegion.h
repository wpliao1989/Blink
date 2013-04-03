//
//  NSString+MKCoordinateRegion.h
//  Blink
//
//  Created by 維平 廖 on 13/4/3.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSString (MKCoordinateRegion)

+ (NSString *)stringFromRegion:(MKCoordinateRegion)region;

@end
