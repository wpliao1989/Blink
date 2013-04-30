//
//  BKScrollableViewController+LoginFlow.h
//  Blink
//
//  Created by 維平 廖 on 13/4/30.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKScrollableViewController.h"

@interface BKScrollableViewController (LoginFlow)

- (void)loginWithAccount:(NSString *)account password:(NSString *)password successBlock:(aBlock)successBlock failBlock:(failBlock)failBlock errorHandler:(void(^)(NSError *error))errorHandler;

@end
