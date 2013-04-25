//
//  BKShopInfo.h
//  
//
//  Created by 維平 廖 on 13/4/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

FOUNDATION_EXPORT NSString *const kBKShopID;
FOUNDATION_EXPORT NSString *const kBKSShopID;

FOUNDATION_EXPORT NSString *const kBKShopName;
FOUNDATION_EXPORT NSString *const kBKShopMenu;
FOUNDATION_EXPORT NSString *const kBKShopPhone;
FOUNDATION_EXPORT NSString *const kBKShopAddress;
FOUNDATION_EXPORT NSString *const kBKShopBusinessHour;
FOUNDATION_EXPORT NSString *const kBKShopLongitude;
FOUNDATION_EXPORT NSString *const kBKShopLatitude;
FOUNDATION_EXPORT NSString *const kBKShopDistance;
FOUNDATION_EXPORT NSString *const kBKShopURL;
FOUNDATION_EXPORT NSString *const kBKShopType;
FOUNDATION_EXPORT NSString *const kBKShopScore;
FOUNDATION_EXPORT NSString *const kBKShopServices;
FOUNDATION_EXPORT NSString *const kBKShopIsProvidingReceipt;
FOUNDATION_EXPORT NSString *const kBKShopCoWorkChannel;
FOUNDATION_EXPORT NSString *const kBKShopDescription;
FOUNDATION_EXPORT NSString *const kBKShopIsDeliverable;
FOUNDATION_EXPORT NSString *const kBKShopDeliverCost;
FOUNDATION_EXPORT NSString *const kBKShopMinPrice;
FOUNDATION_EXPORT NSString *const kBKShopPicURL;

FOUNDATION_EXPORT NSString *const BKShopInfoEmptyString;

@interface BKShopInfo : NSObject

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) NSString *sShopID;

@property (strong, nonatomic) NSString *name;
// Menu is an array of dictionaries(keys: UUID, name, price)
// value of price is a dictionary of size and actual price
@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *businessHours;

@property (nonatomic) CLLocation *shopLocaiton;

@property (strong, nonatomic) NSString *shopURL;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *services;
@property (nonatomic) BOOL isProvidingReceipt;
@property (strong, nonatomic) NSString *cooperation;
@property (strong, nonatomic) NSString *shopDescription;
@property (nonatomic) BOOL isDeliverable;

// Delivery cost and min price
@property (strong, nonatomic) NSNumber *deliverCost;
@property (strong, nonatomic) NSNumber *minPrice;

// Score
@property (strong, nonatomic) NSNumber *score;

// Image
@property (strong, nonatomic) NSURL *pictureURL;
@property (weak, nonatomic) UIImage *pictureImage;

- (id)initWithData:(NSDictionary *)data;
- (void)updateWithData:(NSDictionary *)data;

@end

@interface BKShopInfo (ServiceAndType)

- (BOOL)isServiceFreeDelivery;
- (BOOL)isServiceHasDeliveryCost;

- (NSString *)localizedServiceString;
- (NSString *)localizedTypeString;
+ (NSString *)localizedTypeStringForType:(NSString *)type;

+ (NSArray *)shopTypes;
+ (NSArray *)localizedShopTypes;

+ (NSDictionary *)serviceLookup;
+ (NSDictionary *)typeLookup;

@end
