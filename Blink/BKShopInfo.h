//
//  BKShopInfo.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

FOUNDATION_EXPORT NSString *const kBKShopName;
FOUNDATION_EXPORT NSString *const kBKShopMenu;
FOUNDATION_EXPORT NSString *const kBKShopPhone;
FOUNDATION_EXPORT NSString *const kBKShopAddress;
FOUNDATION_EXPORT NSString *const kBKShopOpenHour;

FOUNDATION_EXPORT NSString *const kBKShopID;
FOUNDATION_EXPORT NSString *const kBKShopExternalID;
FOUNDATION_EXPORT NSString *const kBKShopRegion;
FOUNDATION_EXPORT NSString *const kBKShopLongitude;
FOUNDATION_EXPORT NSString *const kBKShopLatitude;
FOUNDATION_EXPORT NSString *const kBKShopURL;
FOUNDATION_EXPORT NSString *const kBKShopCommerceType;
FOUNDATION_EXPORT NSString *const kBKShopManagerName;
FOUNDATION_EXPORT NSString *const kBKShopManagerPhone;
FOUNDATION_EXPORT NSString *const kBKShopManagerEmail;
FOUNDATION_EXPORT NSString *const kBKShopServicesProviding;
FOUNDATION_EXPORT NSString *const kBKShopIsProvidingReceipt;
FOUNDATION_EXPORT NSString *const kBKShopCoWorkChannel;
FOUNDATION_EXPORT NSString *const kBKShopDescription;
FOUNDATION_EXPORT NSString *const kBKShopIsDeliverable;

@interface BKShopInfo : NSObject

//- (id)initWithName:(NSString *)shopName;
- (id)initWithData:(NSDictionary *)data;

- (void)updateWithData:(NSDictionary *)data sShopID:(NSString *)sShopID;

@property (strong, nonatomic) NSString *name;
// Menu is an array of dictionaries(keys: UUID, name, price)
// value of price is a dictionary of size and actual price
@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *openHours;

@property (strong, nonatomic) NSString *sShopID;
@property (strong, nonatomic) NSString *externalID;
@property (strong, nonatomic) NSString *region;
@property (nonatomic) CLLocation *shopLocaiton;
@property (strong, nonatomic) NSString *shopURL;
@property (strong, nonatomic) NSString *commerceType;
@property (strong, nonatomic) NSString *managerName;
@property (strong, nonatomic) NSString *managerPhone;
@property (strong, nonatomic) NSString *managerEmail;
@property (strong, nonatomic) NSString *servicesProviding;
@property (nonatomic) BOOL isProvidingReceipt;
@property (strong, nonatomic) NSString *coWorkChannel;
@property (strong, nonatomic) NSString *shopDescription;
@property (nonatomic) BOOL isDeliverable;
@property (strong, nonatomic) NSNumber *deliverCost;

@property (strong, nonatomic) NSURL *pictureURL;
@property (weak, nonatomic) UIImage *pictureImage;

@end
