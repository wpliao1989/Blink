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
    return NSLocalizedString(@"Blink", @"Alert title");
}

- (NSString *)confirmButtonTitleForAlertView {
    return NSLocalizedString(@"OK", @"確定 Confirm button title for alert view");
}

- (NSString *)cancelButtonTitleForAlertView {
    return NSLocalizedString(@"Cancel", @"取消 Cancel button title for alert view");
}

- (NSString *)deleteButtonTitleForAlertView {
    return NSLocalizedString(@"Delete", @"刪除 Delete button title for alert view");
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
