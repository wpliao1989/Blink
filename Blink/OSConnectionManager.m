//
//  SAConnectionManager.m
//  Skegeo
//
//  Created by Zhuo TING-RUI on 12/11/29.
//  Copyright (c) 2012年 Flyingman. All rights reserved.
//

#import "OSConnectionManager.h"

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

@implementation OSConnectionManager (ModifyRequest)

- (NSMutableURLRequest *)modifyOriginalRequest:(NSMutableURLRequest *)originalRequest {
    return originalRequest;
}

@end

@implementation OSConnectionManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(OSConnectionManager)

-(NSURLRequest *) defaultHTTPRequestWithPath:(NSString *)path{
    
//    IWAppSetup *appSteup = [IWAppSetup sharedIWAppSetup];
    NSURL *url = [self hostURL];//[appSteup.standardURLAPI URLByAppendingPathComponent:path isDirectory:NO];
    url = [url URLByAppendingPathComponent:path isDirectory:NO];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=utf-8"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    return request;
}

- (void)service:(NSString *)service method:(NSString *)method postData:(NSData *)postData useJSONDecode:(BOOL)useJSON isAsynchronous:(BOOL)isAsynchronous completionHandler:(serviceCompleteHandler)completeHandler{
    
    NSMutableURLRequest *request;
    
    if ([method isEqualToString:@"GET"]) {
        if (postData != nil) {
            NSString *param = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            request= (NSMutableURLRequest *)[self defaultHTTPRequestWithPath:[NSString stringWithFormat:@"%@?%@",service,param]];
        }
        else {
            request= (NSMutableURLRequest *)[self defaultHTTPRequestWithPath:[NSString stringWithFormat:@"%@",service]];
        }
    }else{
        request= (NSMutableURLRequest *)[self defaultHTTPRequestWithPath:[NSString stringWithFormat:@"%@",service]];
        [request setHTTPMethod:method];
        [request setHTTPBody:postData];
    }
    request = [self modifyOriginalRequest:request];    
    
    NSLog(@"Request is %@", request);
    
    NSData *data = nil;
    if (isAsynchronous) {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (useJSON) {
                NSLog(@"service: data string %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                data = [data JSONValue];
            }
            completeHandler(response,data,error);
        }];
    }else{
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (useJSON) {
            //            NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //            NSLog(@"test:%@",test);
            
            data = [data JSONValue];
        }
        completeHandler(response, data, error);
    }   
}

//- (id)service:(NSString *)service method:(NSString *)method postData:(NSData *)postData useJSONDecode:(BOOL)useJSON completionHandler:(serviceCompleteHandler) completeHandler{
//    
//    NSMutableURLRequest *request;
//    
//    if ([method isEqualToString:@"GET"]) {
//        if (postData != nil) {
//            NSString *param = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//            request= (NSMutableURLRequest *)[self defaultHTTPRequestWithPath:[NSString stringWithFormat:@"%@?%@",service,param]];
//        }
//        else {
//            request= (NSMutableURLRequest *)[self defaultHTTPRequestWithPath:[NSString stringWithFormat:@"%@",service]];
//        }        
//    }else{
//        request= (NSMutableURLRequest *)[self defaultHTTPRequestWithPath:[NSString stringWithFormat:@"%@",service]];
//        [request setHTTPMethod:method];
//        [request setHTTPBody:postData];
//    }
//    request = [self modifyOriginalRequest:request];
//    
//    NSHTTPURLResponse *response = nil;
//    NSError *error = nil;
//    
//    NSLog(@"Request is %@", request);
//    
//    NSData *data = nil;
//    if (completeHandler != nil) {
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//            if (useJSON) {
//                NSLog(@"service: data string %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                data = [data JSONValue];
//            }
//            completeHandler(response,data,error);
//        }];
//    }else{
//        data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];        
//        if (useJSON) {
////            NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////            NSLog(@"test:%@",test);
//            
//            data = [data JSONValue];
//        }
//    }
//    
//    
//    return data;    
//}


-(NSString *)specifyStrFromDict:(NSDictionary *)dict withDiv:(NSString *)div{
    
    __block NSDictionary *_dict = dict;
    NSSet *passKeys = [dict keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id key, id obj, BOOL *stop) {
        if ([obj isEqual:@""]) {
            return YES;
        }
        return NO;
    }];
    
    __block NSMutableDictionary *mutableDict = [_dict mutableCopy];
    [passKeys enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [mutableDict removeObjectForKey:obj];
        _dict = mutableDict;
        
    }];
    
    dict = _dict;
    
    NSMutableString *str = [NSMutableString string];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        obj = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(nil,
                                                                          (CFStringRef)obj, nil,
                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
        [str appendFormat:@"%@=%@%@",key,obj,div];
    }];
    return str;
}

-(NSURL *)hostURL{
    return [NSURL URLWithString:@""];
}


@end
