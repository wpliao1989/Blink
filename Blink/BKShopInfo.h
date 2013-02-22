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

@interface BKShopInfo : NSObject

- (id)initWithName:(NSString *)shopName;
- (id)initWithData:(NSDictionary *)data;

@property (strong, nonatomic) NSString *name;
// Menu is an array of dictionaries(keys: UUID, name, price)
// value of price is a dictionary of size and actual price
@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *openHours;

@property (strong, nonatomic) NSString *shopID;
@property (strong, nonatomic) NSString *externalID;
@property (nonatomic) CLLocationCoordinate2D shopCoordinate;
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

@end
