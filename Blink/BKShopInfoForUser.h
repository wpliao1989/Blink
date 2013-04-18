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

FOUNDATION_EXPORT NSString *const kBKShopManagerName;
FOUNDATION_EXPORT NSString *const kBKShopManagerPhone;
FOUNDATION_EXPORT NSString *const kBKShopManagerEmail;

#import "BKShopInfo.h"

@interface BKShopInfoForUser : BKShopInfo

//- (id)initWithName:(NSString *)shopName;
- (id)initWithData:(NSDictionary *)data;

//- (void)updateWithData:(NSDictionary *)data sShopID:(NSString *)sShopID;
- (void)updateWithData:(NSDictionary *)data;

@property (strong, nonatomic) NSString *sShopID;
//@property (strong, nonatomic) NSString *externalID;
//@property (strong, nonatomic) NSString *region;

@property (strong, nonatomic) NSNumber *distance;

//@property (strong, nonatomic) NSString *managerName;
//@property (strong, nonatomic) NSString *managerPhone;
//@property (strong, nonatomic) NSString *managerEmail;

@end

@interface BKShopInfoForUser (ServiceAndType)

- (BOOL)isServiceFreeDelivery;
- (BOOL)isServiceHasDeliveryCost;

- (NSString *)localizedServiceString;
- (NSString *)localizedTypeString;
+ (NSString *)localizedTypeStringForType:(NSString *)type;

+ (NSDictionary *)serviceLookup;
+ (NSDictionary *)typeLookup;

@end

@interface BKShopInfoForUser (Map)<MKAnnotation>

- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;

@end
