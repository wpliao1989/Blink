//
//  BKBaseAPIManager.h
//  
//
//  Created by 維平 廖 on 13/4/3.
//
//

#import "OSConnectionManager.h"
#import "BKAPIError.h"

typedef void (^apiCompleteHandler)(id data, NSError *error);

@interface BKBaseAPIManager : OSConnectionManager

// API calling and handling
- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(asynchronousCompleteHandler)completeHandler;

- (void)handleAPIResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error customWrongResultError:(NSError *)customError completeHandler:(apiCompleteHandler)handler;

// Password encoding
- (NSString *)encodePWD:(NSString *)pwd;

// Response check
- (BOOL)isWrongResult:(id)data;

- (BOOL)isCorrectResult:(id)data;

@end
