//
//  BKAPIManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/19.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//
#import "Base64.h"
#import "Sha1.h"
#import "BKAPIManager.h"
#import "BKOrder.h"
#import "BKAPIError.h"
#import "BKShopInfo.h"
#import "NSMutableArray+Sort.h"

// Notification keys
NSString *const kBKLocationDidChangeNotification = @"kBKLocationDidChangeNotification";
NSString *const kBKLocationBecameAvailableNotification = @"kBKLocationBecameAvailableNotification";

NSString *const kBKServerInfoDidUpdateNotification = @"kBKServerInfoDidUpdateNotification";

// String defined in APIError.h
NSString *const BKErrorDomainWrongResult = @"BKErrorDomainWrongResult";
//NSString *const BKErrorDomainWrongUserNameOrPassword = @"kBKWrongUserNameOrPassword";
//NSString *const BKErrorDomainWrongOrder = @"kBKWrongOrder";
NSString *const BKErrorDomainNetwork = @"BKErrorDomainNetwork";

// Localized string for display
NSString *const BKNetworkNotRespondingMessage = @"網路無回應";
NSString *const BKWrongResultMessage = @"";

// Result decode keys
NSString *const kBKAPIResult = @"result";
NSString *const kBKAPIResultCorrect = @"1";
NSString *const kBKAPIResultWrong = @"0";

// Define Delivery and Takeout method code
typedef NS_ENUM(NSUInteger, BKOrderMethod) {
    BKOrderMethodDelivery = 0,
    BKOrderMethodTakeout = 1    
};

@interface NSData (JSONValue)

- (id) JSONValue;

@end


@implementation NSData (JSONValue)

-(id)JSONValue{
    NSError *error = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) {
        NSLog(@"JSONValue error: %@",error);
    }
    return result;
}

@end

@interface BKAPIManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL isLocationFailed;
- (void)updateToLocation:(CLLocation *)location;

@property (strong, nonatomic) NSArray *listCriteriaKeys;
@property (strong, nonatomic) NSArray *sortCriteriaKeys;
@property (strong, nonatomic) NSDictionary *cityToRegionDict;

//-(id)service:(NSString *)service method:(NSString *)method postData:(NSData *)postData useJSONDecode:(BOOL)useJSON timeout:(NSTimeInterval)time completionHandler:(asynchronousCompleteHandler)completeHandler;
- (NSData *)packedJSONWithFoundationObJect:(id)foundationObject;
- (NSString *)encodePWD:(NSString *)pwd;
- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(asynchronousCompleteHandler)completeHandler;
- (void)handleAPIResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error customWrongResultError:(NSError *)customError completeHandler:(apiCompleteHandler)handler;

- (void)listWithListCriteria:(NSInteger)criteria completionHandler:(asynchronousCompleteHandler)completeHandler;
- (void)sortWithCriteria:(NSInteger)criteria completionHandler:(asynchronousCompleteHandler)completeHandler;
//- (void)handleListAndSortResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error completeHandler:(void (^)(NSArray *, NSArray *))completeHandler;
- (void)handleListAndSortResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error completeHandler:(loadDataCompleteHandler)completeHandler;

- (BOOL)isEmptyCoordinate:(CLLocationCoordinate2D)cooridnate;
- (BOOL)isCorrectResult:(id)data;
- (BOOL)isWrongResult:(id)data;
- (BOOL)isServiceInfoValid;

@end

@implementation BKAPIManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAPIManager)

@synthesize isLoadingData = _isLoadingData;
@synthesize locationManager = _locationManager;
@synthesize isLocationServiceAvailable = _isServiceAvailable;
//@synthesize userCoordinate = _userCoordinate;
@synthesize userLocation = _userLocation;
@synthesize isLocationFailed = _isLocationFailed;
@synthesize cities = _regions;
@synthesize localizedListCriteria = _listCriteria;
@synthesize listCriteriaKeys = _listCriteriaKeys;
@synthesize localizedSortCriteria = _sortCriteria;

#pragma mark - Getters and Setters

- (void)setIsLoadingData:(BOOL)isLoadingData {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isLoadingData;
    _isLoadingData = isLoadingData;    
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0;
    }
    return _locationManager;
}

- (NSArray *)cities {
    if (_regions == nil) {
        _regions = @[];
    }
    return _regions;
}

- (NSDictionary *)cityToRegionDict {
    if (_cityToRegionDict == nil) {
        _cityToRegionDict = @{};
    }
    return _cityToRegionDict;
}

- (NSArray *)localizedListCriteria {
    if (_listCriteria == nil) {
        _listCriteria = @[];
    }
    return _listCriteria;
}

- (NSArray *)listCriteriaKeys {
    if (_listCriteriaKeys == nil) {
        _listCriteriaKeys = @[];
    }
    return _listCriteriaKeys;
}

- (NSArray *)localizedSortCriteria {
    if (_sortCriteria == nil) {
        _sortCriteria = @[];
    }
    return _sortCriteria;
}

//- (void)setUserCoordinate:(CLLocationCoordinate2D)userCoordinate {
//    if ([self isEmptyCoordinate:_userCoordinate]&&(![self isEmptyCoordinate:userCoordinate])) {
//        NSLog(@"userCoordinate became available!");
//        _userCoordinate = userCoordinate;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kBKLocationBecameAvailableNotification object:nil];
//    }
//    _userCoordinate = userCoordinate;
//}

- (void)setUserLocation:(CLLocation *)userLocation {
    if (_userLocation == nil && userLocation != nil) {
        NSLog(@"userCoordinate became available!");
        _userLocation = userLocation;
        [[NSNotificationCenter defaultCenter] postNotificationName:kBKLocationBecameAvailableNotification object:nil];
        return;
    }
    _userLocation = userLocation;
}

#pragma mark - Location

- (BOOL)isLocationServiceAvailable {
    //    NSLog(@"%d, %d", [CLLocationManager locationServicesEnabled], [CLLocationManager authorizationStatus]);
    return ([CLLocationManager locationServicesEnabled]) &&
    ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
    //    &&(self.isLocationFailed == NO);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self updateToLocation:[locations lastObject]];
    return;
    
//    self.isLocationFailed = NO;
    
//    CLLocation *location = [locations lastObject];
//    NSDate *eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
//        NSLog(@"longitude: %f, latitude:%f", location.coordinate.longitude, location.coordinate.latitude);
////        self.userCoordinate = location.coordinate;
//        self.userLocation = location;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kBKLocationDidChangeNotification object:nil];
//        [[BKAPIManager sharedBKAPIManager] listWithListCriteria:BKListCriteriaDistant userCoordinate:self.userCoordinate completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//            NSLog(@"%@", data);            
//        }];
//        [manager stopUpdatingLocation];
//    }
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
////        NSLog(@"Place marks:");
////        for (id thePlacemark in placemarks) {
////            NSLog(@"%@", [thePlacemark class]);
////            NSLog(@"%@", thePlacemark);
////        }
////        NSLog(@"Error: %@", error);
//        CLPlacemark *thePlacemark = [placemarks objectAtIndex:0];
//        NSMutableDictionary *address = [NSMutableDictionary dictionaryWithDictionary:thePlacemark.addressDictionary];
//        [address setObject:@"" forKey:(__bridge NSString *)kABPersonAddressCountryKey];
//        [address setObject:@"" forKey:(__bridge NSString *)kABPersonAddressZIPKey];
//        [address setObject:@"" forKey:(__bridge NSString *)kABPersonAddressStateKey];
//        NSLog(@"%@", address);
//        NSString *formattedAddress = ABCreateStringWithAddressDictionary(address, NO);
//        NSLog(@"%@", formattedAddress);
//    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"did update to location: %@", newLocation);
    [self updateToLocation:newLocation];
}

- (void)updateToLocation:(CLLocation *)location {
    self.isLocationFailed = NO;    
    
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        NSLog(@"longitude: %f, latitude:%f", location.coordinate.longitude, location.coordinate.latitude);
        //        self.userCoordinate = location.coordinate;
        self.userLocation = location;
        [[NSNotificationCenter defaultCenter] postNotificationName:kBKLocationDidChangeNotification object:nil];
        //        [[BKAPIManager sharedBKAPIManager] listWithListCriteria:BKListCriteriaDistant userCoordinate:self.userCoordinate completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        //            NSLog(@"%@", data);
        //        }];
        //        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Locatoin manager failed with error %@", error);
    self.isLocationFailed = YES;
}

- (void)startUpdatingUserLocation {
    NSLog(@"isLocationFailed = %d", self.isLocationFailed);
//    NSLog(@"%f %f", self.userCoordinate.longitude, self.userCoordinate.latitude);
    NSLog(@"%f %f", self.userLocation.coordinate.longitude, self.userLocation.coordinate.latitude);
//    NSLog([self isEmptyCoordinate:self.userCoordinate]? @"YES":@"NO");
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingUserLocation {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Utility methods

- (BOOL)isEmptyCoordinate:(CLLocationCoordinate2D)cooridnate {
    return (cooridnate.latitude == 0.0) && (cooridnate.longitude == 0.0);
}

- (BOOL)isServiceInfoValid {
    return self.localizedListCriteria.count > 0 && self.localizedSortCriteria.count > 0;
}

- (NSData *)packedJSONWithFoundationObJect:(id)foundationObject {   
    static NSString *encodeKey = @"data";
    
    NSError *firstEncodedDataError;    
    NSData *firstEncodedData = [NSJSONSerialization dataWithJSONObject:foundationObject options:0 error:&firstEncodedDataError];
    if (firstEncodedDataError) {
        NSLog(@"%@", firstEncodedDataError);
    }
    NSString *firstEncodedDataString = [[NSString alloc] initWithData:firstEncodedData encoding:NSUTF8StringEncoding];
//    NSLog(@"firstEncodedDataString = %@", firstEncodedDataString);
    
    NSDictionary *secondDataToBeEncoded = @{encodeKey : firstEncodedDataString};
    NSError *secondEncodedError;
    NSData *secondEncodedData = [NSJSONSerialization dataWithJSONObject:secondDataToBeEncoded options:0 error:&secondEncodedError];
    if (secondEncodedError) {
        NSLog(@"%@", secondEncodedError);
    }    
    NSString *secondEncodedDataString = [[NSString alloc] initWithData:secondEncodedData encoding:NSUTF8StringEncoding];    
//    NSLog(@"secondEncodedDataString = %@", secondEncodedDataString);
    
    NSString *result = [NSString stringWithFormat:@"%@=%@",encodeKey, secondEncodedDataString];
    NSData *encodedData = [result dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"finalResult:%@",result);
//    NSMutableDictionary *finalDataToBeEncoded = [NSMutableDictionary dictionary];
//    [finalDataToBeEncoded setValue:secondEncodedDataString forKey:encodeKey];
//    NSError *finalEncodedError;
//    NSData *encodedData =[NSJSONSerialization dataWithJSONObject:finalDataToBeEncoded options:0 error:&finalEncodedError];
//    if (finalEncodedError) {
//        NSLog(@"%@", finalEncodedError);
//    }
//    NSLog(@"finalDataToBeEncoded = %@", finalDataToBeEncoded);
//    NSData *encodedData =
    return encodedData;
}

- (NSString *)encodePWD:(NSString *)pwd {
//    NSString *sha1String = [Sha1 dataUsingSha1:pwd];
//    NSLog(@"sha1String: %@", sha1String);
//    
//    NSString *base64String = [Base64 encodeWithNSString:sha1String];
//    NSLog(@"base64String: %@", base64String);
    
//    NSString *base64String123 = [Base64 encodeWithNSString:@"ffc9bb611e2b3c47f74b12293c29924a5ff872cc"];
//    NSLog(@"base64String123: %@", base64String123);
    
    return [Base64 encode:[Sha1 dataUsingSha1:pwd]];
}

- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(asynchronousCompleteHandler)completeHandler {
    NSData *encodedPostBody = [self packedJSONWithFoundationObJect:postBody];
    NSLog(@"postBody = %@", [[NSString alloc] initWithData:encodedPostBody encoding:NSUTF8StringEncoding]);
    [self service:apiName method:@"POST" postData:encodedPostBody useJSONDecode:YES completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//        NSLog(@"callAPI, data:%@", data);
//        self.isLoadingData = NO;
        completeHandler(response, data, error);
    }];
}

- (void)handleAPIResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error customWrongResultError:(NSError *)customError completeHandler:(apiCompleteHandler)handler {
    NSLog(@"response = %@", response);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"status code = %d", statusCode);
    NSLog(@"data = %@", data);
    NSLog(@"error = %@", error);
    
    if (error != nil || statusCode != 200) {
        NSError *BKError = [NSError errorWithDomain:BKErrorDomainNetwork code:0 userInfo:@{kBKErrorMessage : BKNetworkNotRespondingMessage}];
        handler(nil, BKError);
    }
    else if (![self isCorrectResult:data]) {
        NSError *wrongResultError;
        if (customError) {
            wrongResultError = customError;
        }
        else {
            wrongResultError = [NSError errorWithDomain:BKErrorDomainWrongResult code:BKErrorWrongResultGeneral userInfo:@{kBKErrorMessage : BKErrorDomainWrongResult}];
        }
        handler(nil, wrongResultError);
    }
    else {
        handler(data, nil);
    }
}

#pragma mark - Get regions

- (NSArray *)regionsForCity:(NSString *)city {
    return [self.cityToRegionDict objectForKey:city];
}

#pragma mark - OSConnectionManager overwrite

- (NSMutableURLRequest *)modifyOriginalRequest:(NSMutableURLRequest *)originalRequest {
    [originalRequest setTimeoutInterval:10.0];
    NSLog(@"timeout = %f", originalRequest.timeoutInterval);
    return originalRequest;
}

- (NSURL *)hostURL {
    return [NSURL URLWithString:@"http://www.blink.com.tw:8051/Mobile"];
}

#pragma mark - Returned data checking

- (BOOL)isCorrectResult:(id)data {
//    NSLog(@"result class: %@", [[data objectForKey:kBKAPIResult] class]);
    if (data != nil && [data isKindOfClass:[NSDictionary class]] && [[data objectForKey:kBKAPIResult] isEqualToString:kBKAPIResultCorrect]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWrongResult:(id)data {
    if (data != nil && [data isKindOfClass:[NSDictionary class]] && [[data objectForKey:kBKAPIResult] isEqualToString:kBKAPIResultWrong]) {
        return YES;
    }
    return NO;
}

#pragma mark - APIs

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(apiCompleteHandler)completeHandler {
    static NSString *kUserName = @"username";
    static NSString *kPWD = @"password";
    
    NSDictionary *parameterDictionary = @{kUserName : userName, kPWD : [self encodePWD:password]};
    [self callAPI:@"login" withPostBody:parameterDictionary completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        
        NSError *customError = [NSError errorWithDomain:BKErrorDomainWrongResult code:BKErrorWrongResultUserNameOrPassword userInfo:@{kBKErrorMessage : @"帳號或密碼錯誤"}];
        
        [self handleAPIResponse:response data:data error:error customWrongResultError:customError completeHandler:completeHandler];
//        if (error != nil) {
//            NSError *BKError = [NSError errorWithDomain:BKErrorDomainNetwork code:0 userInfo:@{kBKErrorMessage : BKNetworkNotRespondingMessage}];
//            completeHandler(nil, BKError);
//        }
////        else if ([self isCorrectResult:data]) {
////            completeHandler(data, nil);
////        }
//        else if ([self isWrongResult:data]) {            
//            NSError *wrongResultError = [NSError errorWithDomain:BKErrorDomainWrongUserNameOrPassword code:0 userInfo:];
//            completeHandler(nil, wrongResultError);
//        }
//        else {
//            completeHandler(data, nil);
//        }
    }];
}

//- (void)handleListAndSortResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error completeHandler:(void (^)(NSArray *, NSArray *))completeHandler {
//    static NSString *kShopIDs = @"sShopID";
//    
//    NSLog(@"response: %@", response);
//    NSLog(@"data :%@", data);
//    NSLog(@"error: %@", error);
//    
//    __block NSMutableArray *shopIDs = [[data objectForKey:kShopIDs] mutableCopy];
//    __block NSMutableDictionary *shopRawDatas = [NSMutableDictionary dictionary];
//    
//    for (id theShopID in shopIDs) {
//        NSLog(@"theShopID class: %@", [theShopID class]);
//    }
//    
//    if (shopIDs.count == 0) {
//        self.isLoadingData = NO;
//        completeHandler(shopIDs, @[]);
//    }
//    
//    for (int i = 0; i < shopIDs.count; i++) {
//        NSString *theShopID = [shopIDs objectAtIndex:i];
//        
//        [self shopDetailWithShopID:theShopID completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//            //                NSLog(@"the shop id :%@", theShopID);
//            NSLog(@"shop detail data :%@", data);
//            NSLog(@"shop service: %@", [data objectForKey:@"service"]);
//            NSLog(@"shop commerceType: %@", [data objectForKey:@"commerceType"]);
//            //                NSLog(@"Shop name:%@", [data objectForKey:@"name"]);
//            NSLog(@"shop detail data class: %@", [data class]);
//            if (data == nil) {
//                [shopIDs removeObject:theShopID];
//            }
//            else {
//                [shopRawDatas setObject:data forKey:theShopID];
//            }
//            
//            //                NSLog(@"shopRawDatas: %@", shopRawDatas);
//            if (shopRawDatas.count == shopIDs.count) {
//                
//                NSMutableArray *rawDatas = [NSMutableArray array];
//                for (int j = 0; j < shopIDs.count; j++) {
//                    [rawDatas addObject:[shopRawDatas objectForKey:[shopIDs objectAtIndex:j]]];
//                }
//                self.isLoadingData = NO;
//                completeHandler(shopIDs, rawDatas);
//            }
//        }];
//    }
//}

- (void)handleListAndSortResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error completeHandler:(loadDataCompleteHandler)completeHandler {
    static NSString *kShops = @"shop";
    
    NSLog(@"response: %@", response);
    NSLog(@"data :%@", data);
    NSLog(@"error: %@", error);
    
//    NSArray *shops = data[kShops];
//    for (NSDictionary *dict in shops) {
//        NSString *distance = @"distance";
//        NSString *lat = @"lat";
//        NSString *lng = @"lng";
//        NSString *minprice = @"minprice";
//        NSString *score = @"score";
//        NSString *service = @"service";
//        NSString *shopID = @"sShopID";
//        NSString *type = @"type";
//        NSLog(@"distance is %@, class is %@", dict[distance], [dict[distance] class]);
//        NSLog(@"lat is %@, class is %@", dict[lat], [dict[lat] class]);
//        NSLog(@"lng is %@, class is %@", dict[lng], [dict[lng] class]);
//        NSLog(@"minprice is %@, class is %@", dict[minprice], [dict[minprice] class]);
//        NSLog(@"score is %@, class is %@", dict[score], [dict[score] class]);
//        NSLog(@"service is %@, class is %@", dict[service], [dict[service] class]);
//        NSLog(@"shopID is %@, class is %@", dict[shopID], [dict[shopID] class]);
//        NSLog(@"type is %@, class is %@", dict[type], [dict[type] class]);
//    }
    
    NSArray *shopRawDatas = data[kShops];
    self.isLoadingData = NO;
    
    if (shopRawDatas.count == 0) {        
        completeHandler(@[], @[]);
    }
    else {
        NSMutableArray *shopIDs = [NSMutableArray array];
        for (NSDictionary *dict in shopRawDatas) {
            [shopIDs addObject:dict[kBKSShopID]];
        }
        completeHandler([NSArray arrayWithArray:shopIDs], shopRawDatas);
    }   
}

- (void)loadDataWithListCriteria:(NSInteger)criteria completeHandler:(loadDataCompleteHandler)completeHandler {   
    [self listWithListCriteria:criteria completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        [self handleListAndSortResponse:response data:data error:error completeHandler:completeHandler];     
    }];
}

- (void)loadDataWithSortCriteria:(NSInteger)criteria completeHandler:(loadDataCompleteHandler)completeHandler {
    [self sortWithCriteria:criteria completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        [self handleListAndSortResponse:response data:data error:error completeHandler:completeHandler];
    }];
}

- (void)listWithListCriteria:(NSInteger)criteria completionHandler:(asynchronousCompleteHandler)completeHandler {
    static NSString *kListCriteria = @"listCriteria";
    static NSString *kLongitude = @"longitude";
    static NSString *kLatitude = @"latitude";   
    
    if ([self isEmptyCoordinate:self.userLocation.coordinate]) {
        NSLog(@"Warning: userCoordinate is empty!");      
        return;
    }
    
    if (criteria >= self.listCriteriaKeys.count || criteria < 0) {
        NSLog(@"Warning: invalid list criteria! %d", criteria);
        NSLog(@"list criteria keys = %@", self.listCriteriaKeys);
        NSLog(@"localized list criterias = %@", self.localizedListCriteria);
        return;
    }   
    
    NSDictionary *parameterDictionary;
//    NSLog(@"!!!! %@", [self.listCriteria class]);
    NSString *criteriaString = [self.listCriteriaKeys objectAtIndex:criteria];
    
    parameterDictionary = @{ kListCriteria : criteriaString,
                             kLongitude : [NSNumber numberWithDouble:self.userLocation.coordinate.longitude],
                             kLatitude : [NSNumber numberWithDouble:self.userLocation.coordinate.latitude]};
    
    self.isLoadingData = YES;
    [self callAPI:@"list" withPostBody:parameterDictionary completionHandler:completeHandler];
}

- (void)sortWithCriteria:(NSInteger)criteria completionHandler:(asynchronousCompleteHandler)completeHandler {
    static NSString *kSortCriteria = @"sortCriteria";
    static NSString *kLongitude = @"longitude";
    static NSString *kLatitude = @"latitude";
    
    NSNumber *latitude = [NSNumber numberWithDouble:self.userLocation.coordinate.latitude];
    NSNumber *longitude =[NSNumber numberWithDouble:self.userLocation.coordinate.longitude];
    
    if (criteria >= self.localizedSortCriteria.count || criteria < 0) {
        NSLog(@"Warning: invalid sort criteria!");
        return;
    }   
    
    NSDictionary *parameterDictionary;
    NSString *criteriaString = [self.sortCriteriaKeys objectAtIndex:criteria];
    
    parameterDictionary = @{ kSortCriteria : criteriaString, kLatitude : latitude, kLongitude : longitude};
    
    self.isLoadingData = YES;
    [self callAPI:@"sort" withPostBody:parameterDictionary completionHandler:completeHandler];    
}

- (void)searchWithShopName:(NSString *)shopName completionHandler:(asynchronousCompleteHandler)completeHandler{
    static NSString *kShopName = @"ShopName";
    
    NSDictionary *parameterDictionary = @{kShopName : shopName};
    [self callAPI:@"search" withPostBody:parameterDictionary completionHandler:completeHandler];
//    NSData *postBody = [self packedJSONWithFoundationObJect:parameterDictionary];
//    NSLog(@"postBody = %@", [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);
//   [self service:@"search" method:@"POST" postData:postBody useJSONDecode:YES completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//        NSLog(@"%@", data);
//       completeHandler(response, data, error);
//    }];    
}

- (void)shopDetailWithShopID:(NSString *)shopID completionHandler:(asynchronousCompleteHandler)completeHandler {
    static NSString *kShopID = @"sShopID";
    static NSString *kLongitude = @"longitude";
    static NSString *kLatitude = @"latitude";
    
    NSNumber *latitude = [NSNumber numberWithDouble:self.userLocation.coordinate.latitude];
    NSNumber *longitude =[NSNumber numberWithDouble:self.userLocation.coordinate.longitude];
    
    NSDictionary *parameterDictionary = @{kShopID : shopID, kLatitude : latitude, kLongitude : longitude};
    self.isLoadingData = YES;
    [self callAPI:@"shop" withPostBody:parameterDictionary completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        self.isLoadingData = NO;
        completeHandler(response, data, error);
    }];
}

- (void)orderWithData:(BKOrder *)order completionHandler:(apiCompleteHandler)completeHandler {
    NSString *kBKOrderUserToken = @"token";
    NSString *kBKOrderShopID = @"sShopID";    
    NSString *kBKOrderUserAddress = @"address";
    NSString *kBKOrderUserPhone = @"phone";
    NSString *kBKOrderContent = @"content";
    NSString *kBKNote = @"note";
    NSString *kBKOrderUserName = @"name";
    NSString *kBKOrderRecordTime = @"time";
    NSString *kBKOrderMethod = @"method";
    
//    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
//    [parameterDictionary setObject:order.userToken forKey:kBKOrderUserToken];
//    [parameterDictionary setObject:order.shopID forKey:kBKOrderShopID];
//    [parameterDictionary setObject:order.recordTime forKey:kBKOrderRecordTime];
//    [parameterDictionary setObject:order.address forKey:kBKOrderUserAddress];
//    [parameterDictionary setObject:order.phone forKey:kBKOrderUserPhone];
//    [parameterDictionary setObject:order.content.count != 0? order.content : [NSNull null] forKey:kBKOrderContent];
    
//    NSLog(@"order.content.count = %d", order.content.count);
//    NSLog(@"order.content = %@", order.content);
    
    NSDictionary *parameterDictionary =   @{kBKOrderUserToken: order.userToken,
                                          kBKOrderShopID : order.shopID,
                                          kBKOrderRecordTime : order.recordTime,
                                          kBKOrderUserAddress : order.address,
                                          kBKOrderUserPhone : order.phone,
                                          kBKOrderContent : order.content,
                                            kBKNote : order.note,
                                            kBKOrderUserName : order.userName,
                                            kBKOrderMethod : order.method};
    
    NSLog(@"order = %@", parameterDictionary);
    
    [self callAPI:@"order" withPostBody:parameterDictionary completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        
        NSError *customError = [NSError errorWithDomain:BKErrorDomainWrongResult code:BKErrorWrongResultOrder userInfo:@{kBKErrorMessage:@"訂單錯誤"}];
        
        [self handleAPIResponse:response data:data error:error customWrongResultError:customError completeHandler:completeHandler];
        
//        if (error != nil) {
//            NSError *BKError = [NSError errorWithDomain:BKErrorDomainNetwork code:0 userInfo:@{kBKErrorMessage : BKNetworkNotRespondingMessage}];
//            completeHandler(nil, BKError);
//        }        
//        else if (![self isCorrectResult:data]) {
//            NSError *wrongResultError = [NSError errorWithDomain:BKErrorDomainWrongOrder code:0 userInfo:@{kBKErrorMessage:@"訂單錯誤"}];
//            completeHandler(nil, wrongResultError);
//        }
//        else {            
//            completeHandler(data, nil);
//        }
    }];
}

- (void)updateServerInfo {
    static NSString *kRegion = @"region";
    static NSString *kListCriteria = @"listCriteria";
//    static NSString *kSortCriteria = @"sortCriteria";
    
    self.isLoadingData = YES;
    
    [self service:@"info" method:@"GET" postData:nil useJSONDecode:YES completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        NSLog(@"response = %@", response);
        NSLog(@"data = %@", data);
        NSLog(@"error = %@", error);
        
        if ([self isCorrectResult:data]) {
            
            id regionObject = [data objectForKey:kRegion];
            [self updateRegionWithObject:regionObject];
            
            id listCriteriaObject = [data objectForKey:kListCriteria];
            [self updateListCriteriaWithObject:listCriteriaObject];            

            [self updateSortCriteria];
            
        }
        
        if (![self isServiceInfoValid]) {
            double delayInSeconds = 10.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self updateServerInfo];
            });            
        }
        else {
            self.isLoadingData = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kBKServerInfoDidUpdateNotification object:nil];
        }
    }];
}

#pragma mark - Update info methods

- (void)updateListCriteriaWithObject:(id)listCriteriaObject {
    if (listCriteriaObject != [NSNull null] && [listCriteriaObject isKindOfClass:[NSDictionary class]]) {
        NSString *kListCriteriaDistant = @"distant";
        NSString *kListCriteriaPrice = @"price";
        NSString *kListCriteriaScore = @"score";
        NSArray *sortOrder = @[kListCriteriaDistant, kListCriteriaPrice, kListCriteriaScore];
        
        NSDictionary *listCriteriaDict = listCriteriaObject;
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *values = [NSMutableArray array];        
        
        keys = [[listCriteriaDict allKeys] mutableCopy];
        [keys sortUsingAnotherArray:sortOrder];
        
        for (NSString *theKey in keys) {
            //NSLog(@"the key = %@, the value = %@", theKey, [listCriteriaDict objectForKey:theKey]);
            [values addObject:[listCriteriaDict objectForKey:theKey]];
        }
        
        self.listCriteriaKeys = [keys copy];
        //NSLog(@"keys !!!!!! %@   %@", self.listCriteriaKeys, keys);
        self.localizedListCriteria = [[NSArray alloc] initWithArray:values];
        
        //                for (NSString *theListCriteria in [[data objectForKey:kListCriteria] allValues]) {
        //                    NSLog(@"list criteria: %@", theListCriteria);
        //                }
        //
        //                NSLog(@"list criteria: %@", [data objectForKey:kListCriteria]);
    }
    else {
        self.listCriteriaKeys = @[@"distant", @"price", @"score"];
        self.localizedListCriteria = @[@"依距離", @"依價格", @"依評價"];
    }
}

- (void)updateRegionWithObject:(id)regionObject {
    if (regionObject != [NSNull null] && [regionObject isKindOfClass:[NSArray class]]) {        
        NSMutableArray *cities = [NSMutableArray array];
        NSMutableDictionary *citiesToRegionsTable = [NSMutableDictionary dictionary];
        
        for (NSArray *cityAndRegions in regionObject) {
            NSString *cityName = [cityAndRegions objectAtIndex:0];
            NSArray *regions = [cityAndRegions objectAtIndex:1];
            
            [cities addObject:cityName];
            [citiesToRegionsTable setObject:regions forKey:cityName];
        }
        
        self.cities = [NSArray arrayWithArray:cities];
        self.cityToRegionDict = [NSDictionary dictionaryWithDictionary:citiesToRegionsTable];
    }
//    NSLog(@"regions: %@, class: %@", regionObject, [regionObject class]);
//    for (id object in regionObject) {
//        NSLog(@"object: %@, class: %@", object, [object class]);
//        for (id innerObject in object) {
//            NSLog(@"inner object: %@, class: %@", innerObject, [innerObject class]);
//        }
//    }
}

- (void)updateSortCriteria {
//    self.sortCriteriaKeys = @[@"1",
//                              @"2",
//                              @"3",
//                              @"4",
//                              @"5",
//                              @"6",
//                              @"7",
//                              @"8",
//                              @"9",
//                              @"10",
//                              @"11",
//                              @"12",
//                              @"13",
//                              @"14",
//                              @"15",
//                              @"16",
//                              @"17",
//                              @"18",
//                              @"19",
//                              @"20",
//                              @"21",
//                              @"22"];
    self.sortCriteriaKeys = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"SortCriteriaArray" withExtension:@"plist"]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *sortCriteria in self.sortCriteriaKeys) {
        //NSLog(@"sortCriteria: %@", sortCriteria);
        [array addObject:[BKShopInfo localizedTypeStringForType:sortCriteria]];
    }
    self.localizedSortCriteria = [NSArray arrayWithArray:array];
}


@end
