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
#import "BKSearchOption.h"

@class BKOrder;
@class BKSearchParameter;

FOUNDATION_EXPORT NSString *const kBKLocationDidChangeNotification;
FOUNDATION_EXPORT NSString *const kBKLocationBecameAvailableNotification;
FOUNDATION_EXPORT NSString *const kBKServerInfoDidUpdateNotification;

typedef void (^loadDataCompleteHandler)(NSArray *shopIDs, NSArray *rawDatas);

#import "BKBaseAPIManager.h"

@interface BKAPIManager : BKBaseAPIManager<CLLocationManagerDelegate>

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
//- (void)loadDataWithListCriteria:(NSInteger)criteria parameter:(BKSearchParameter *)parameter completeHandler:(loadDataCompleteHandler)completeHandler;
//
//- (void)loadDataWithSortCriteria:(NSInteger)criteria parameter:(BKSearchParameter *)parameter completeHandler:(loadDataCompleteHandler)completeHandler;
- (void)loadData:(BKSearchOption)option criteria:(NSInteger)criteria parameter:(BKSearchParameter *)parameter completeHandler:(loadDataCompleteHandler)completeHandler;

- (void)shopDetailWithShopID:(NSString *)shopID completionHandler:(serviceCompleteHandler) completeHandler;

- (void)searchWithShopName:(NSString *)shopName completionHandler:(serviceCompleteHandler) completeHandler;

- (void)orderWithData:(BKOrder *)order completionHandler:(apiCompleteHandler) completeHandler;

- (void)updateServerInfo;

@end

