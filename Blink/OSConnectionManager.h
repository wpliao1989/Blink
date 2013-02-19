//
//  SAConnectionManager.h
//  Skegeo
//
//  Created by Zhuo TING-RUI on 12/11/29.
//  Copyright (c) 2012年 Flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

typedef void (^asynchronousCompleteHandler)(NSURLResponse *response, id data, NSError *error);


@interface OSConnectionManager : NSObject


CWL_DECLARE_SINGLETON_FOR_CLASS(OSConnectionManager)

- (NSURL *) hostURL;

-(NSURLRequest *) defaultHTTPRequestWithPath:(NSString *)path;
- (id)service:(NSString *)service method:(NSString *)method postData:(NSData *)postData useJSONDecode:(BOOL)useJSON completionHandler:(asynchronousCompleteHandler) completeHandler;
-(NSString *)specifyStrFromDict:(NSDictionary *)dict withDiv:(NSString *)div;

@end
