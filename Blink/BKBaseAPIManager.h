//
//  BKBaseAPIManager.h
//  
//
//  Created by 維平 廖 on 13/4/3.
//
//

#import "OSConnectionManager.h"
#import "BKAPIError.h"

FOUNDATION_EXPORT NSString *const kToken;
FOUNDATION_EXPORT NSString *const kUserName;
FOUNDATION_EXPORT NSString *const kEmail;
FOUNDATION_EXPORT NSString *const kPWD;

FOUNDATION_EXPORT NSString *const kBKServerInfoDidUpdateNotification;

typedef void (^apiCompleteHandler)(id data, NSError *error);

@interface BKBaseAPIManager : OSConnectionManager

@property (nonatomic, readonly) BOOL loadingServerInfo;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSDictionary *cityToRegionDict;

// API calling and handling
- (void)callAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(serviceCompleteHandler)completeHandler;
- (void)callSynchronousAPI:(NSString *)apiName withPostBody:(NSDictionary *)postBody completionHandler:(serviceCompleteHandler)completeHandler;

- (void)handleAPIResponse:(NSURLResponse *)response data:(id)data error:(NSError *)error customWrongResultError:(NSError *)customError completeHandler:(apiCompleteHandler)handler;

// Password encoding
- (NSString *)encodePWD:(NSString *)pwd;

// Response check
- (BOOL)isWrongResult:(id)data;
- (BOOL)isCorrectResult:(id)data;
- (BOOL)isAccountNotActivatedResult:(id)data;

@end

@interface BKBaseAPIManager (Addition)

- (NSString *)generateBoundaryString;
- (void)sendPushToken:(NSString *)pushToken userToken:(NSString *)userToken completeHandler:(apiCompleteHandler)handler;

- (void)forgetPasswordUserAccount:(NSString *)account email:(NSString *)email completionHandler:(apiCompleteHandler) completeHandler;
- (void)editUserPWD:(NSString *)password token:(NSString *)token completionHandler:(apiCompleteHandler)completeHandler;

- (void)updateServerInfo;
- (void)updateListCriteriaWithObject:(id)listCriteriaObject;
- (void)updateSortCriteria;
- (BOOL)isServiceInfoValid;

@end
