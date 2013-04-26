//
//  UIViewController+SharedString.m
//  Blink
//
//  Created by 維平 廖 on 13/4/23.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+SharedString.h"

@implementation UIViewController (SharedString)

- (NSString *)titleForAlertView {
    return @"Blink";
}

- (NSString *)confirmButtonTitleForAlertView {
    return @"確定";
}

- (NSString *)cancelButtonTitleForAlertView {
    return @"取消";
}

- (NSString *)deleteButtonTitleForAlertView {
    return @"刪除";
}

- (void)showAlert:(NSString *)alertMsg {
    if (![alertMsg isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:[self titleForAlertView]
                                    message:alertMsg
                                   delegate:nil
                          cancelButtonTitle:[self confirmButtonTitleForAlertView]
                          otherButtonTitles:nil] show];
    }
}

@end
