//
//  BKShopInfo.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfo.h"
#import "BKMenuItem.h"

NSString *const kBKShopName = @"name";
NSString *const kBKShopMenu = @"menu";
NSString *const kBKShopPhone = @"phone";
NSString *const kBKShopAddress = @"address";
NSString *const kBKShopOpenHour = @"businessHours";

NSString *const kBKShopID = @"mShopID";
NSString *const kBKShopExternalID = @"extID";
NSString *const kBKShopRegion = @"region";
NSString *const kBKShopLongitude = @"long";
NSString *const kBKShopLatitude = @"lat";
NSString *const kBKShopURL = @"url";
NSString *const kBKShopCommerceType = @"commerceType";
NSString *const kBKShopManagerName = @"managerName";
NSString *const kBKShopManagerPhone = @"managerPhone";
NSString *const kBKShopManagerEmail = @"managerEmail";
NSString *const kBKShopServicesProviding = @"service";
NSString *const kBKShopIsProvidingReceipt = @"withReceipt";
NSString *const kBKShopCoWorkChannel = @"coWorkChannel";
NSString *const kBKShopDescription = @"intro";
NSString *const kBKShopIsDeliverable = @"deliverable";

@interface BKShopInfo ()

@property (strong, nonatomic) NSDictionary *data;

@end

@implementation BKShopInfo

@synthesize data = _data;

@synthesize name = _name;
@synthesize menu = _menu;
@synthesize phone = _phone;
@synthesize address = _address;
@synthesize openHours = _openHours;

@synthesize shopID = _shopID;
@synthesize externalID = _externalID;
@synthesize region = _region;
@synthesize shopCoordinate = _shopCoordinate;
@synthesize shopURL = _shopURL;
@synthesize commerceType = _commerceType;
@synthesize managerName = _managerName;
@synthesize managerPhone = _managerPhone;
@synthesize managerEmail = _managerEmail;
@synthesize servicesProviding = _servicesProviding;
@synthesize isProvidingReceipt = _isProvidingReceipt;
@synthesize coWorkChannel = _coWorkChannel;
@synthesize shopDescription = _shopDescription;
@synthesize isDeliverable = _isDeliverable;

//- (id)initWithName:(NSString *)shopName {
//    self = [super init];
//    if (self) {
//        self.name = shopName;
//    }
//    return self;
//}

- (NSString *)name {
    return [self.data objectForKey:kBKShopName];
}

- (NSArray *)menu {
    if (_menu == nil) {
        NSMutableArray *newMemuArray = [NSMutableArray array];
        NSArray *arrayOfDicts = [self.data objectForKey:kBKShopMenu];
        for (NSDictionary *menuItem in arrayOfDicts) {
            [newMemuArray addObject:[[BKMenuItem alloc] initWithData:menuItem]];
        }
        _menu = [NSArray arrayWithArray:newMemuArray];
    }
    return _menu;
}

- (NSString *)phone {
    return [self.data objectForKey:kBKShopPhone];
}

- (NSString *)address {
    return [self.data objectForKey:kBKShopAddress];
}

- (NSString *)openHours {
    return [self.data objectForKey:kBKShopOpenHour];
}

- (NSString *)shopDescription {
    return [self.data objectForKey:kBKShopDescription];
}

- (NSString *)shopID {
    return [self.data objectForKey:kBKShopID];
}

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.data = data;
//        self.shopID = [data objectForKey:kBKShopID];
//        self.name = [data objectForKey:kBKShopName];
//        self.menu = [data objectForKey:kBKShopMenu];
//        self.phone = [data objectForKey:kBKShopPhone];
//        self.address = [data objectForKey:kBKShopAddress];
//        self.openHours = [data objectForKey:kBKShopOpenHour];
//        self.shopDescription = [data objectForKey:kBKShopDescription];
    }
    return self;
}

- (void)updateWithData:(NSDictionary *)data {
    self.data = data;
    self.menu = nil;
}

@end
