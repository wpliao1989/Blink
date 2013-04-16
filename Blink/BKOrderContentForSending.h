//
//  BKOrder.h
//  Blink
//
//  Created by Wei Ping on 13/2/20.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKOrderContent.h"

@class BKMenuItemForReceiving;

@interface BKOrderContentForSending : BKOrderContent

- initWithMenu:(BKMenuItemForReceiving *)menu ice:(NSString *)ice sweetness:(NSString *)sweetness quantity:(NSNumber *)quantity size:(NSString *)size;

- (NSDictionary *)contentForAPI;
- (BOOL)isEqualExceptQuantity:(BKOrderContentForSending *)theOrderContent;

@end
