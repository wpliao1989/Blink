//
//  BKShopInfo.m
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopInfo.h"
#import "BKMenuItem.h"
#import "NSObject+NullObject.h"

NSString *const kBKShopName = @"name";
NSString *const kBKShopMenu = @"menu";
NSString *const kBKShopPhone = @"phone";
NSString *const kBKShopAddress = @"address";
NSString *const kBKShopBusinessHour = @"businessHours";

NSString *const kBKSShopID = @"sShopID";
//NSString *const kBKShopExternalID = @"extID";
//NSString *const kBKShopRegion = @"region";
NSString *const kBKShopLongitude = @"lng";
NSString *const kBKShopLatitude = @"lat";
NSString *const kBKShopDistance = @"distance";
NSString *const kBKShopURL = @"url";
NSString *const kBKShopType = @"type";
NSString *const kBKShopScore = @"score";
//NSString *const kBKShopManagerName = @"managerName";
//NSString *const kBKShopManagerPhone = @"managerPhone";
//NSString *const kBKShopManagerEmail = @"managerEmail";
NSString *const kBKShopServices = @"service";
NSString *const kBKShopIsProvidingReceipt = @"withReceipt";
NSString *const kBKShopCoWorkChannel = @"coWorkChannel";
NSString *const kBKShopDescription = @"intro";
NSString *const kBKShopIsDeliverable = @"deliverable";
NSString *const kBKShopDeliverCost = @"deliverCost";
NSString *const kBKShopMinPrice = @"minprice";
NSString *const kBKShopPicURL = @"pic";

static NSString *emptyString = @"Null content";

@interface BKShopInfo ()

@property (strong, nonatomic) NSDictionary *data;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end

@implementation BKShopInfo

@synthesize data = _data;

@synthesize name = _name;
@synthesize menu = _menu;
@synthesize phone = _phone;
@synthesize address = _address;
@synthesize businessHours = _openHours;

@synthesize sShopID = _shopID;
//@synthesize externalID = _externalID;
//@synthesize region = _region;
@synthesize shopLocaiton = _shopLocaiton;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize shopURL = _shopURL;
@synthesize type = _commerceType;
//@synthesize managerName = _managerName;
//@synthesize managerPhone = _managerPhone;
//@synthesize managerEmail = _managerEmail;
@synthesize services = _servicesProviding;
@synthesize isProvidingReceipt = _isProvidingReceipt;
@synthesize cooperation = _coWorkChannel;
@synthesize shopDescription = _shopDescription;
@synthesize isDeliverable = _isDeliverable;
@synthesize deliverCost = _deliverCost;
@synthesize pictureURL = _pictureURL;

//- (id)initWithName:(NSString *)shopName {
//    self = [super init];
//    if (self) {
//        self.name = shopName;
//    }
//    return self;
//}

#pragma mark - Shop basic infos

- (NSString *)sShopID {
    id object = self.data[kBKSShopID];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

- (NSString *)name {
    id object = self.data[kBKShopName];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
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
    id object = self.data[kBKShopPhone];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

- (NSString *)address {
    id object = self.data[kBKShopAddress];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

#pragma mark - Location

- (CLLocationDegrees)latitude {
    id object = self.data[kBKShopLatitude];
    if ([object isNullOrNil] || ![object isNumber]) {
        return 0.0;
    }
    return [object doubleValue];
}

- (CLLocationDegrees)longitude {
    id object = self.data[kBKShopLongitude];
    if ([object isNullOrNil] || ![object isNumber]) {
        return 0.0;
    }
    return [object doubleValue];
}

- (CLLocation *)shopLocaiton {
    if (_shopLocaiton == nil) {
        _shopLocaiton = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    }
    return _shopLocaiton;
}

- (NSNumber *)distance {
    id object = self.data[kBKShopDistance];
    if ([object isNullOrNil] || ![object isNumber]) {
        return @(-1);
    }
    return object;
}

#pragma mark - Descriptions

- (NSString *)type {
    id object = self.data[kBKShopType];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

- (NSString *)businessHours {
    id object = self.data[kBKShopBusinessHour];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }    
    return object;
}

- (NSString *)shopURL {
    id object = self.data[kBKShopURL];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

- (NSString *)shopDescription {
    id object = self.data[kBKShopDescription];
    if ([object isNullOrNil] || ![object isString]) {
        return emptyString;
    }
    return object;
}

- (NSNumber *)deliverCost {
    id object = self.data[kBKShopDeliverCost];
    if ([object isNullOrNil] || ![object isNumber]) {
        return @(-1);
    }
    return object;
}

- (NSURL *)pictureURL {
    id object = self.data[kBKShopPicURL];
    if ([object isNullOrNil] || ![object isString]) {
        return nil;
    }
    return [NSURL URLWithString:object];
}

//- (NSString *)shopID {
//    if ([self.data objectForKey:kBKShopID] == [NSNull null]) {
//        return emptyString;
//    }
//    return [self.data objectForKey:kBKShopID];
//}

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

//- (void)updateWithData:(NSDictionary *)data sShopID:(NSString *)sShopID {
//    self.data = data;
//    self.menu = nil;
//    self.shopLocaiton = nil;
//    self.shopID = sShopID;
//}

- (void)updateWithData:(NSDictionary *)data {
    self.data = data;
    self.menu = nil;
    self.shopLocaiton = nil;
}

@end
