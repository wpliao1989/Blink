//
//  BKShopInfo.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "BKShopInfo.h"

@interface BKShopInfoForUser : BKShopInfo

@property (strong, nonatomic) NSNumber *distance;

@end

@interface BKShopInfoForUser (Map)<MKAnnotation>

- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;

@end
