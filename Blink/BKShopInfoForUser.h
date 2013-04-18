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

FOUNDATION_EXPORT NSString *const kBKShopID;
FOUNDATION_EXPORT NSString *const kBKSShopID;
FOUNDATION_EXPORT NSString *const kBKShopExternalID;
FOUNDATION_EXPORT NSString *const kBKShopRegion;

#import "BKShopInfo.h"

@interface BKShopInfoForUser : BKShopInfo

@property (strong, nonatomic) NSString *sShopID;
//@property (strong, nonatomic) NSString *externalID;
//@property (strong, nonatomic) NSString *region;

@property (strong, nonatomic) NSNumber *distance;

@end

@interface BKShopInfoForUser (Map)<MKAnnotation>

- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;

@end
