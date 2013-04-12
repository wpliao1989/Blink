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
#import "NSNumber+NullNumber.h"

NSString *const kBKShopName = @"name";
NSString *const kBKShopMenu = @"menu";
NSString *const kBKShopPhone = @"phone";
NSString *const kBKShopAddress = @"address";
NSString *const kBKShopBusinessHour = @"businessHours";

NSString *const kBKShopID = @"shopID";
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

NSString *const BKShopInfoEmptyString = @"Null content";

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
        object = self.data[kBKShopID];
        if ([object isNullOrNilOrNotString]) {
            return BKShopInfoEmptyString;
        }        
    }
    return object;
}

- (NSString *)name {
    id object = self.data[kBKShopName];
    if ([object isNullOrNil] || ![object isString]) {
        return BKShopInfoEmptyString;
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
        return BKShopInfoEmptyString;
    }
    return object;
}

- (NSString *)address {
    id object = self.data[kBKShopAddress];
    if ([object isNullOrNil] || ![object isString]) {
        return BKShopInfoEmptyString;
    }
    return object;
}

#pragma mark - Location

- (CLLocationDegrees)latitude {
    id object = self.data[kBKShopLatitude];
    //NSLog(@"Warning: latitude is %@, class %@", object, [object class]);
    if ([object isNullOrNil] || ![object isNumber]) {
        if ([object isString]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            NSNumber *lat = [formatter numberFromString:object];
            if (lat) {
                return [lat doubleValue];
            }
        }
        return 0.0;
    }
    return [object doubleValue];
}

- (CLLocationDegrees)longitude {
    id object = self.data[kBKShopLongitude];
    //NSLog(@"Warning: longitude is %@, class %@", object, [object class]);
    if ([object isNullOrNil] || ![object isNumber]) {
        if ([object isString]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            NSNumber *lon = [formatter numberFromString:object];
            if (lon) {
                return [lon doubleValue];
            }
        }
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
        return [NSNumber nullNumber];
    }
    return object;
}

#pragma mark - Descriptions

- (NSString *)services {
    id object = self.data[kBKShopServices];
    if ([object isNullOrNil] || ![object isString]) {
        return BKShopInfoEmptyString;
    }
    return object;
}

- (NSString *)type {
    id object = self.data[kBKShopType];
    if ([object isNullOrNil] || ![object isString]) {
        return BKShopInfoEmptyString;
    }
    return object;
}

- (NSNumber *)score {
    id object = self.data[kBKShopScore];
    if ([object isNullOrNil] || ![object isNumber]) {
        return @(0);
    }
    return object;
}

- (NSString *)businessHours {
    id object = self.data[kBKShopBusinessHour];
    if ([object isNullOrNil] || ![object isString]) {
        return BKShopInfoEmptyString;
    }    
    return object;
}

- (NSString *)shopURL {
    id object = self.data[kBKShopURL];
    if ([object isNullOrNil] || ![object isString]) {
        return BKShopInfoEmptyString;
    }
    return object;
}

- (NSString *)shopDescription {
    id object = self.data[kBKShopDescription];
    if ([object isNullOrNil] || ![object isString]) {
        return BKShopInfoEmptyString;
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

- (NSNumber *)minPrice {    
    id object = self.data[kBKShopMinPrice];
    NSLog(@"minprice:%@, class:%@", object, [object class]);
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

#pragma mark - Data

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

// Service
NSString *const BKShopInfoServiceTakeout = @"1";
NSString *const BKShopInfoServiceFreeDeliver = @"2";
NSString *const BKShopInfoServiceTakeoutAndDeliver = @"3";
NSString *const BKShopInfoServiceChargeDeliver = @"4";
NSString *const BKShopInfoServiceNone = @"5";

@implementation BKShopInfo (ServiceAndType)

- (BOOL)isServiceFreeDelivery {
    return [self.services isEqualToString:BKShopInfoServiceFreeDeliver] || [self.services isEqualToString:BKShopInfoServiceTakeoutAndDeliver];
}

- (BOOL)isServiceHasDeliveryCost {
    return [self.services isEqualToString:BKShopInfoServiceChargeDeliver];
}

- (NSString *)localizedServiceString {
    return [[[self class] serviceLookup] objectForKey:self.services];
}

- (NSString *)localizedTypeString {
    return [[self class] localizedTypeStringForType:self.type];
}

+ (NSString *)localizedTypeStringForType:(NSString *)type {
    return [[[self class] typeLookup] objectForKey:type];
}

+ (NSDictionary *)serviceLookup {
    static NSDictionary *serviceLookup;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceLookup = @{BKShopInfoServiceTakeout: @"外帶",
                          BKShopInfoServiceFreeDeliver: @"外送",
                          BKShopInfoServiceTakeoutAndDeliver: @"外帶+外送",
                          BKShopInfoServiceChargeDeliver: @"自費外送",
                          BKShopInfoServiceNone: @"皆無"};
    });
    
    return serviceLookup;
}

+ (NSDictionary *)typeLookup {
    static NSDictionary *typeLookup;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        typeLookup = @{@"1" : @"中式料理",
//                       @"2" : @"日式料理",
//                       @"3" : @"亞洲料理",
//                       @"4" : @"泰式料理",
//                       @"5" : @"美式料理",
//                       @"6" : @"韓式料理",
//                       @"7" : @"港式料理",
//                       @"8" : @"義式料理",
//                       @"9"  : @"輕食",
//                       @"10" : @"其他異國料理",
//                       @"11" : @"燒烤類",
//                       @"12" : @"鍋類",
//                       @"13" : @"咖啡、簡餐、茶",
//                       @"14" : @"素食",
//                       @"15" : @"速食料理",
//                       @"16" : @"主題特色餐廳",
//                       @"17" : @"早餐",
//                       @"18" : @"buffet自助餐",
//                       @"19" : @"小吃",
//                       @"20" : @"冰品、飲料、甜湯",
//                       @"21" : @"烘焙、甜點、零食",
//                       @"22" : @"其他美食"};
        typeLookup = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"TypeDictionary" withExtension:@"plist"]];
    });
    return typeLookup;
}

@end

@implementation BKShopInfo (Map)

- (CLLocationCoordinate2D)coordinate {
    return self.shopLocaiton.coordinate;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return [self localizedTypeString];
}

@end
