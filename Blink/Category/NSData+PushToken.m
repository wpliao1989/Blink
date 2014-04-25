//
//  NSData+PushToken.m
//  Jingo
//
//  Created by 維平 廖 on 13/4/24.
//
//

#import "NSData+PushToken.h"

@implementation NSData (PushToken)

- (NSString *)stringInHexForPushToken {
    const char *charPtr = (char *)self.bytes;
    NSMutableString *deviceTokenString = [NSMutableString string];
    
    for (int i = 0; i < self.length; i++) {
        //        NSLog(@"char[%d]: %02.2hhx", i, charPtr[i]);
        [deviceTokenString appendFormat:@"%02.2hhx", charPtr[i]];
    }
    
    return [NSString stringWithString:deviceTokenString];
}

@end
