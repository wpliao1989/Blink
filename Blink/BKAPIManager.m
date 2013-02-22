//
//  BKAPIManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/19.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAPIManager.h"

NSString *const kBKLocationDidChangeNotification = @"kBKLocationDidChangeNotification";
NSString *const kBKLocationBecameAvailableNotification = @"kBKLocationBecameAvailableNotification";

@interface BKAPIManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL isLocationFailed;

- (NSData *)packedJSONWithFoundationObJect:(id)foundationObject;
- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(asynchronousCompleteHandler)completeHandler;

- (BOOL)isEmptyCoordinate:(CLLocationCoordinate2D)cooridnate;

@end

@implementation BKAPIManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAPIManager)

@synthesize isLoadingData = _isLoadingData;
@synthesize locationManager = _locationManager;
@synthesize isLocationServiceAvailable = _isServiceAvailable;
@synthesize userCoordinate = _userCoordinate;
@synthesize isLocationFailed = _isLocationFailed;

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0;
    }
    return _locationManager;
}

- (void)setUserCoordinate:(CLLocationCoordinate2D)userCoordinate {
    if ([self isEmptyCoordinate:_userCoordinate]&&(![self isEmptyCoordinate:userCoordinate])) {
        NSLog(@"userCoordinate became available!");
        _userCoordinate = userCoordinate;
        [[NSNotificationCenter defaultCenter] postNotificationName:kBKLocationBecameAvailableNotification object:nil];
    }
    _userCoordinate = userCoordinate;
}

- (BOOL)isLocationServiceAvailable {
//    NSLog(@"%d, %d", [CLLocationManager locationServicesEnabled], [CLLocationManager authorizationStatus]);    
    return ([CLLocationManager locationServicesEnabled]) &&
    ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
//    &&(self.isLocationFailed == NO);
}

- (NSURL *)hostURL {
    return [NSURL URLWithString:@"http://www.blink.com.tw:8051/Mobile"];
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.isLocationFailed = NO;
    
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        NSLog(@"longitude: %f, latitude:%f", location.coordinate.longitude, location.coordinate.latitude);
        self.userCoordinate = location.coordinate;
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
    NSLog(@"%f %f", self.userCoordinate.longitude, self.userCoordinate.latitude);
    NSLog([self isEmptyCoordinate:self.userCoordinate]? @"YES":@"NO");
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

- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(asynchronousCompleteHandler)completeHandler {
    NSData *encodedPostBody = [self packedJSONWithFoundationObJect:postBody];
    NSLog(@"postBody = %@", [[NSString alloc] initWithData:encodedPostBody encoding:NSUTF8StringEncoding]);
    [self service:apiName method:@"POST" postData:encodedPostBody useJSONDecode:YES completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        //        NSLog(@"%@", data);
        self.isLoadingData = NO;
        completeHandler(response, data, error);
    }];
}

#pragma mark - APIs

- (void)listWithListCriteria:(BKListCriteria)criteria completionHandler:(asynchronousCompleteHandler)completeHandler {
    static NSString *kListCriteria = @"listCriteria";
    static NSString *kLongitude = @"longitude";
    static NSString *kLatitude = @"latitude";
    NSString *criteriaString;    
    NSDictionary *parameterDictionary;    
    
    self.isLoadingData = YES;
    
    switch (criteria) {
        case BKListCriteriaDistant:
            criteriaString = @"distant";
            if ([self isEmptyCoordinate:self.userCoordinate]) {                
                NSLog(@"Warning: userCoordinate is empty!");
                self.isLoadingData = NO;
                return;
            }
            parameterDictionary = @{ kListCriteria : criteriaString, kLongitude : [[NSString alloc] initWithFormat:@"%f", self.userCoordinate.longitude], kLatitude : [[NSString alloc] initWithFormat:@"%f", self.userCoordinate.latitude]};
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
    [self callAPI:@"search" withPostBody:parameterDictionary completionHandler:completeHandler];
}

- (void)orderWithData:(NSDictionary *)order completionHandler:(asynchronousCompleteHandler)completeHandler {
    
    [self callAPI:@"order" withPostBody:order completionHandler:completeHandler];
}

@end
