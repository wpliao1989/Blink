//
//  BKAPIManager.m
//  Blink
//
//  Created by Wei Ping on 13/2/19.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAPIManager.h"

@interface BKAPIManager ()

- (NSData *)packedJSONWithFoundationObJect:(id)foundationObject;
- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(asynchronousCompleteHandler)completeHandler;

@end

@implementation BKAPIManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKAPIManager)

- (NSURL *)hostURL {
    return [NSURL URLWithString:@"http://www.blink.com.tw:8051/Mobile"];
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
        completeHandler(response, data, error);
    }];
}

#pragma mark - APIs

- (void)listWithListCriteria:(BKListCriteria)criteria userCoordinate:(CLLocationCoordinate2D)userCoordinate completionHandler:(asynchronousCompleteHandler)completeHandler {
    static NSString *kListCriteria = @"listCriteria";
    static NSString *kLongitude = @"longitude";
    static NSString *kLatitude = @"latitude";
    NSString *criteriaString;    
    NSDictionary *parameterDictionary;
    
    switch (criteria) {
        case BKListCriteriaDistant:
            criteriaString = @"distant";
            parameterDictionary = @{ kListCriteria : criteriaString, kLongitude : [[NSString alloc] initWithFormat:@"%f", userCoordinate.longitude], kLatitude : [[NSString alloc] initWithFormat:@"%f", userCoordinate.latitude]};
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

@end
