//
//  BKScrollableViewController+LoginFlow.m
//  Blink
//
//  Created by 維平 廖 on 13/4/30.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKScrollableViewController+LoginFlow.h"
#import "BKAccountManager.h"

@implementation BKScrollableViewController (LoginFlow)

- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
            successBlock:(aBlock)successBlock
               failBlock:(failBlock)failBlock
            errorHandler:(void (^)(NSError *))errorHandler {
    
    [[BKAccountManager sharedBKAccountManager] loginWithAccount:account
                                                       password:password
                                                CompleteHandler:^(BOOL success, NSError *error) {
        if (success) {
            [[BKAccountManager sharedBKAccountManager] saveUserPreferedAccount:account
                                                                      password:password];
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:YES completion:^{}];
            });
            successBlock(BKLoginSuccessMessage);
        }
        else {
            if ([error.domain isEqualToString:BKErrorDomainWrongResult] &&
                (error.code == BKErrorWrongResultUserNameOrPassword)) {
                [[BKAccountManager sharedBKAccountManager] saveUserPreferedAccount:account
                                                                          password:nil];
            }
            if (errorHandler) {
                errorHandler(error);
            }
//            else if ([error.domain isEqualToString:BKErrorDomainWrongResult] &&
//                     (error.code == BKErrorWrongResultAccountNotActivated)) {
//                double delayInSeconds = 1.0;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [self performSegueWithIdentifier:@"loginToActivationSegue" sender:self];
//                });
//            }
            failBlock(error);
        }
    }];
}

@end
