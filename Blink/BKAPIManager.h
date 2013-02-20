//
//  BKAPIManager.h
//  Blink
//
//  Created by Wei Ping on 13/2/19.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OSConnectionManager.h"
#import "CWLSynthesizeSingleton.h"

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSInteger, BKListCriteria) {
  BKListCriteriaDistant = 1,
  BKListCriteriaPrice = 2,
  BKListCriteriaScore = 3
};

@interface BKAPIManager : OSConnectionManager

CWL_DECLARE_SINGLETON_FOR_CLASS(BKAPIManager)

- (void)listWithListCriteria:(BKListCriteria)criteria userCoordinate:(CLLocationCoordinate2D)userCoordinate completionHandler:(asynchronousCompleteHandler)completeHandler;
- (void)searchWithShopName:(NSString *)shopName completionHandler:(asynchronousCompleteHandler) completeHandler;
- (void)shopDetailWithShopID:(NSString *)shopID completionHandler:(asynchronousCompleteHandler) completeHandler;

@end
