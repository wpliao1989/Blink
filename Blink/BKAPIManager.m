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

NSString *const kBKLocationDidChangeNotification = @"kBKLocationDidChangeNotification";
NSString *const kBKLocationBecameAvailableNotification = @"kBKLocationBecameAvailableNotification";

NSString *const BKErrorDomainWrongUserNameOrPassword = @"kBKWrongUserNameOrPassword";
NSString *const BKErrorDomainWrongOrder = @"kBKWrongOrder";

NSString *const kBKAPIResult = @"result";
NSString *const kBKAPIResultCorrect = @"1";
NSString *const kBKAPIResultWrong = @"0";

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

-(id)service:(NSString *)service method:(NSString *)method postData:(NSData *)postData useJSONDecode:(BOOL)useJSON timeout:(NSTimeInterval)time completionHandler:(asynchronousCompleteHandler)completeHandler;
- (NSData *)packedJSONWithFoundationObJect:(id)foundationObject;
- (NSString *)encodePWD:(NSString *)pwd;
- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(asynchronousCompleteHandler)completeHandler;

- (void)listWithListCriteria:(BKListCriteria)criteria completionHandler:(asynchronousCompleteHandler)completeHandler;
- (void)shopDetailWithShopID:(NSString *)shopID completionHandler:(asynchronousCompleteHandler) completeHandler;

- (BOOL)isEmptyCoordinate:(CLLocationCoordinate2D)cooridnate;
- (BOOL)isCorrectResult:(id)data;
- (BOOL)isWrongResult:(id)data;

@end

@implementation BKAPIManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAPIManager)

@synthesize isLoadingData = _isLoadingData;
@synthesize locationManager = _locationManager;
@synthesize isLocationServiceAvailable = _isServiceAvailable;
//@synthesize userCoordinate = _userCoordinate;
@synthesize userLocation = _userLocation;
@synthesize isLocationFailed = _isLocationFailed;

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
    self.isLocationFailed = NO;
    
    CLLocation *location = [locations lastObject];
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
        
        if (error != nil) {
            completeHandler(nil, error);
        }
//        else if ([self isCorrectResult:data]) {
//            completeHandler(data, nil);
//        }
        else if ([self isWrongResult:data]) {            
            NSError *wrongResultError = [NSError errorWithDomain:BKErrorDomainWrongUserNameOrPassword code:0 userInfo:nil];
            completeHandler(nil, wrongResultError);
        }
        else {
            completeHandler(data, nil);
        }
    }];
}

- (void)loadDataWithListCriteria:(BKListCriteria)criteria completeHandler:(void (^)(NSArray *, NSArray *))completeHandler {   
    static NSString *kShopIDs = @"sShopID";
    
    [self listWithListCriteria:criteria completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        NSLog(@"response: %@", response);
        NSLog(@"data :%@", data);
        NSLog(@"error: %@", error);
        
        __block NSMutableArray *shopIDs = [[data objectForKey:kShopIDs] mutableCopy];
        __block NSMutableDictionary *shopRawDatas = [NSMutableDictionary dictionary];
        
        if (shopIDs.count == 0) {
            self.isLoadingData = NO;
            completeHandler(shopIDs, @[]);
        }
        
        for (int i = 0; i < shopIDs.count; i++) {
            NSString *theShopID = [shopIDs objectAtIndex:i];
        
            [self shopDetailWithShopID:theShopID completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//                NSLog(@"the shop id :%@", theShopID);
                NSLog(@"shop detail data :%@", data);
                NSLog(@"shop service: %@", [data objectForKey:@"service"]);
                NSLog(@"shop commerceType: %@", [data objectForKey:@"commerceType"]);
//                NSLog(@"Shop name:%@", [data objectForKey:@"name"]);
                NSLog(@"shop detail data class: %@", [data class]);
                if (data == nil) {                    
                    [shopIDs removeObject:theShopID];
                }
                else {
                    [shopRawDatas setObject:data forKey:theShopID];
                }
                
//                NSLog(@"shopRawDatas: %@", shopRawDatas);
                if (shopRawDatas.count == shopIDs.count) {                   
                    
                    NSMutableArray *rawDatas = [NSMutableArray array];
                    for (int j = 0; j < shopIDs.count; j++) {
                        [rawDatas addObject:[shopRawDatas objectForKey:[shopIDs objectAtIndex:j]]];
                    }
                    self.isLoadingData = NO;
                    completeHandler(shopIDs, rawDatas);                    
                }
            }];
        }        
    }];   
}

- (void)listWithListCriteria:(BKListCriteria)criteria completionHandler:(asynchronousCompleteHandler)completeHandler {
    static NSString *kListCriteria = @"listCriteria";
    static NSString *kLongitude = @"longitude";
    static NSString *kLatitude = @"latitude";
    NSString *criteriaString;    
    NSDictionary *parameterDictionary;    
    
    self.isLoadingData = YES;
    
    if ([self isEmptyCoordinate:self.userLocation.coordinate]) {
        NSLog(@"Warning: userCoordinate is empty!");
        self.isLoadingData = NO;
        return;
    }
    
    switch (criteria) {
        case BKListCriteriaDistant:
            criteriaString = @"distant";
//            if ([self isEmptyCoordinate:self.userCoordinate]) {                
//                NSLog(@"Warning: userCoordinate is empty!");
//                self.isLoadingData = NO;
//                return;
//            }
//            parameterDictionary = @{ kListCriteria : criteriaString, kLongitude : [[NSString alloc] initWithFormat:@"%f", self.userCoordinate.longitude], kLatitude : [[NSString alloc] initWithFormat:@"%f", self.userCoordinate.latitude]};
            break;
        case BKListCriteriaPrice:
            criteriaString = @"price";
            parameterDictionary = @{ kListCriteria : criteriaString};
            break;
        case BKListCriteriaScore:
            criteriaString = @"score";
            parameterDictionary = @{ kListCriteria : criteriaString};
            break;
        default:
            NSLog(@"Warning: criteria is undefined, value: %d", criteria);
            break;
    }    
    
    parameterDictionary = @{ kListCriteria : criteriaString, kLongitude : [NSNumber numberWithDouble:self.userLocation.coordinate.longitude], kLatitude : [NSNumber numberWithDouble:self.userLocation.coordinate.latitude]};
    
    [self callAPI:@"list" withPostBody:parameterDictionary completionHandler:completeHandler];
//    NSData *postBody = [self packedJSONWithFoundationObJect:parameterDictionary];    
//    NSLog(@"postBody = %@", [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding]);    
//    [self service:@"list" method:@"POST" postData:postBody useJSONDecode:YES completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//        NSLog(@"%@", data);
//        completeHandler(response, data, error);
//    }];    
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
    
    NSDictionary *parameterDictionary = @{kShopID : shopID};
    [self callAPI:@"shop" withPostBody:parameterDictionary completionHandler:completeHandler];
}

- (void)orderWithData:(BKOrder *)order completionHandler:(apiCompleteHandler)completeHandler {
    static NSString *kBKOrderUserToken = @"token";
    static NSString *kBKOrderShopID = @"sShopID";
    static NSString *kBKOrderRecordTime = @"recordTime";
    static NSString *kBKOrderUserAddress = @"address";
    static NSString *kBKOrderUserPhone = @"phone";
    static NSString *kBKOrderContent = @"content";
    static NSString *kBKNote = @"note";
    static NSString *kBKOrderUserName = @"name";
    
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
                                            kBKOrderUserName : order.userName};
    
    NSLog(@"order = %@", parameterDictionary);
    
    [self callAPI:@"order" withPostBody:parameterDictionary completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        NSLog(@"data = %@", data);
        
        if (error != nil) {            
            completeHandler(nil, error);
        }        
        else if ([self isWrongResult:data]) {            
            NSError *wrongResultError = [NSError errorWithDomain:BKErrorDomainWrongOrder code:0 userInfo:nil];
            completeHandler(nil, wrongResultError);
        }
        else {            
            completeHandler(data, nil);
        }
    }];
}

@end
