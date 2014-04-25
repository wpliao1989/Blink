//
//  NSData+PushToken.h
//  Jingo
//
//  Created by 維平 廖 on 13/4/24.
//
//

#import <Foundation/Foundation.h>

@interface NSData (PushToken)

// Returns a string in hex formate suitable for push token usage
- (NSString *)stringInHexForPushToken;

@end
