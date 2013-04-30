//
//  BKBaseAPIManager.m
//  
//
//  Created by 維平 廖 on 13/4/3.
//
//

#import "BKBaseAPIManager.h"
#import "Sha1.h"
#import "Base64.h"

// Result decode keys
NSString *const kBKAPIResult = @"result";
NSString *const kBKAPIResultCorrect = @"1";
NSString *const kBKAPIResultWrong = @"0";
NSString *const kBKAPIResultAccountNotActivated = @"-1";

NSString *const BKErrorDomainWrongResult = @"com.flyingman.BKErrorDomainWrongResult";
//NSString *const BKErrorDomainWrongUserNameOrPassword = @"kBKWrongUserNameOrPassword";
//NSString *const BKErrorDomainWrongOrder = @"kBKWrongOrder";
NSString *const BKErrorDomainNetwork = @"com.flyingman.BKErrorDomainNetwork";

// Localized string for display
NSString *const BKNetworkNotRespondingMessage = @"伺服器無回應";
NSString *const BKWrongResultMessage = @"";

// Custom error message key
//NSString *const kBKErrorMessage = @"kBKErrorMessage";

@interface BKBaseAPIManager (Internal)

- (NSData *)packedJSONWithFoundationObJect:(id)foundationObject;

@end

@implementation BKBaseAPIManager (Internal)

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

@end

@implementation BKBaseAPIManager

- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(serviceCompleteHandler)completeHandler {
    NSData *encodedPostBody = [self packedJSONWithFoundationObJect:postBody];
    NSLog(@"postBody = %@", [[NSString alloc] initWithData:encodedPostBody encoding:NSUTF8StringEncoding]);
    [self service:apiName
           method:@"POST"
         postData:encodedPostBody
      contentType:nil  
    useJSONDecode:YES isAsynchronous:YES completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//        NSLog(@"callAPI, data:%@", data);
//        self.isLoadingData = NO;
        completeHandler(response, data, error);
    }];
}

- (void)callSynchronousAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(serviceCompleteHandler)completeHandler {
    NSData *encodedPostBody = [self packedJSONWithFoundationObJect:postBody];
    NSLog(@"postBody = %@", [[NSString alloc] initWithData:encodedPostBody encoding:NSUTF8StringEncoding]);
    [self service:apiName
           method:@"POST"
         postData:encodedPostBody
      contentType:nil
    useJSONDecode:YES
   isAsynchronous:YES
completionHandler:completeHandler];
}

- (void)handleAPIResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error customWrongResultError:(NSError *)customError completeHandler:(apiCompleteHandler)handler {
    //NSLog(@"response = %@", response);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpResponse statusCode];
    //NSLog(@"status code = %d", statusCode);
    //NSLog(@"data = %@", data);
    //NSLog(@"error = %@", error);
    
    if (error != nil || statusCode != 200) {
        NSLog(@"Error:%@", error);
        NSLog(@"Localized description:%@", error.localizedDescription);
        NSLog(@"Failure reason:%@", error.localizedFailureReason);
        NSLog(@"Recovery option:%@", error.localizedRecoveryOptions);
        NSLog(@"Recovery suggestion:%@", error.localizedRecoverySuggestion);
        //NSString *localizedDescription = error.localizedDescription != nil ? error.localizedDescription : BKNetworkNotRespondingMessage;
        NSError *BKError; 
        // Status code is not 200
        if (error == nil) {
            BKError = [NSError errorWithDomain:BKErrorDomainNetwork code:BKErrorWrongResultGeneral userInfo:@{NSLocalizedDescriptionKey : BKNetworkNotRespondingMessage}];
        }
        else {
            BKError = [NSError errorWithDomain:BKErrorDomainNetwork
                                          code:BKErrorWrongResultGeneral
                                      userInfo:error.userInfo];
        }
        
        handler(nil, BKError);
    }
    else if (![self isCorrectResult:data]) {
        
        if ([self isAccountNotActivatedResult:data]) {
            NSError *wrongResultError = [NSError errorWithDomain:BKErrorDomainWrongResult
                                                            code:BKErrorWrongResultAccountNotActivated
                                                        userInfo:@{NSLocalizedDescriptionKey : @"帳號尚未認證"}];
            
            handler(nil, wrongResultError);
        }
        else {
            NSError *wrongResultError;
            if (customError) {
                wrongResultError = customError;
            }
            else {
                wrongResultError = [NSError errorWithDomain:BKErrorDomainWrongResult
                                                       code:BKErrorWrongResultGeneral
                                                   userInfo:error.userInfo];
            }
            handler(nil, wrongResultError);
        }        
    }
    else {
        handler(data, nil);
    }
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

- (BOOL)isWrongResult:(id)data {
    if (data != nil && [data isKindOfClass:[NSDictionary class]] && [[data objectForKey:kBKAPIResult] isEqualToString:kBKAPIResultWrong]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCorrectResult:(id)data {
//    NSLog(@"result class: %@", [[data objectForKey:kBKAPIResult] class]);
    if (data != nil && [data isKindOfClass:[NSDictionary class]] && [[data objectForKey:kBKAPIResult] isEqualToString:kBKAPIResultCorrect]) {
        return YES;
    }
    return NO;
}

- (BOOL)isAccountNotActivatedResult:(id)data {
    if (data != nil && [data isKindOfClass:[NSDictionary class]] && [[data objectForKey:kBKAPIResult] isEqualToString:kBKAPIResultAccountNotActivated]) {
        return YES;
    }
    return NO;
}

@end

@implementation BKBaseAPIManager (Addition)

- (NSString *)generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

- (void)sendPushToken:(NSString *)pushToken userToken:(NSString *)userToken completeHandler:(apiCompleteHandler)handler{
    NSString *const pushTokenKey = @"regID";
    NSString *const deviceTypeKey = @"deviceType";
    NSString *const kDevice = @"ios";
    
    NSDictionary *parameterDictionary = @{kToken : userToken, pushTokenKey : pushToken, deviceTypeKey : kDevice};
    
    [self callAPI:@"push" withPostBody:parameterDictionary completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        [self handleAPIResponse:response data:data error:error customWrongResultError:nil completeHandler:handler
         ];
    }];
}

- (void)editUserPWD:(NSString *)password token:(NSString *)token completionHandler:(apiCompleteHandler)completeHandler {
    NSString *kNewPWD = @"newpwd";
    
    NSDictionary *parameterDictionary = @{kToken : token,
                                          kNewPWD : [self encodePWD:password]
                                          };
    [self callAPI:@"pwd_edit" withPostBody:parameterDictionary completionHandler:^(NSURLResponse *response, id data, NSError *error) {
        
        NSError *customError = [NSError errorWithDomain:BKErrorDomainWrongResult code:BKErrorWrongResultUserNameOrPassword userInfo:@{NSLocalizedDescriptionKey : @"修改密碼錯誤"}];
        
        [self handleAPIResponse:response data:data error:error customWrongResultError:customError completeHandler:completeHandler];
    }];
}

@end
