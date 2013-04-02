//
//  BKAPIManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/19.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/ABAddressFormatting.h>
#import <AddressBook/ABPerson.h>
#import "OSConnectionManager.h"
#import "CWLSynthesizeSingleton.h"

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

@class BKOrder;

//typedef NS_ENUM(NSInteger, BKListCriteria) {
//  BKListCriteriaDistant = 1,
//  BKListCriteriaPrice = 2,
//  BKListCriteriaScore = 3
//};

FOUNDATION_EXPORT NSString *const kBKLocationDidChangeNotification;
FOUNDATION_EXPORT NSString *const kBKLocationBecameAvailableNotification;
FOUNDATION_EXPORT NSString *const kBKServerInfoDidUpdateNotification;

typedef void (^apiCompleteHandler)(id data, NSError *error);
typedef void (^loadDataCompleteHandler)(NSArray *shopIDs, NSArray *rawDatas);

@interface BKAPIManager : OSConnectionManager<CLLocationManagerDelegate>

CWL_DECLARE_SINGLETON_FOR_CLASS(BKAPIManager)

// Location
@property (nonatomic) BOOL isLocationServiceAvailable;
//@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (strong, nonatomic) CLLocation *userLocation;

- (void)startUpdatingUserLocation;
- (void)stopUpdatingUserLocation;

// BOOL flag indicating whether APIManager is loading new data
@property (nonatomic) BOOL isLoadingData;

// Server info
@property (strong, nonatomic) NSArray *cities;
- (NSArray *)regionsForCity:(NSString *)city;
@property (strong, nonatomic) NSArray *localizedListCriteria;
@property (strong, nonatomic) NSArray *localizedSortCriteria;

// APIs
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(apiCompleteHandler) completeHandler;

//- (void)loadDataWithListCriteria:(NSInteger)criteria completeHandler:(void (^)(NSArray *shopIDs, NSArray *shopRawDatas))completeHandler;
- (void)loadDataWithListCriteria:(NSInteger)criteria completeHandler:(loadDataCompleteHandler)completeHandler;

- (void)loadDataWithSortCriteria:(NSInteger)criteria completeHandler:(loadDataCompleteHandler)completeHandler;

- (void)shopDetailWithShopID:(NSString *)shopID completionHandler:(asynchronousCompleteHandler) completeHandler;

- (void)searchWithShopName:(NSString *)shopName completionHandler:(asynchronousCompleteHandler) completeHandler;

- (void)orderWithData:(BKOrder *)order completionHandler:(apiCompleteHandler) completeHandler;

- (void)updateServerInfo;

@end

