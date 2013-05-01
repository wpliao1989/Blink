//
//  UIViewController+SharedString.m
//  Blink
//
//  Created by 維平 廖 on 13/4/23.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+SharedString.h"

NSString *const kNoUserNameMessage = @"請輸入姓名";
NSString *const kNoAccountMessage = @"請填入帳號";
NSString *const kNoPasswordMessage = @"請填入密碼";
NSString *const kWrongPasswordMessage = @"密碼錯誤";
NSString *const kPasswordNotTheSameMessage = @"請填入相同密碼";
NSString *const kNoEmailMessage = @"請填入email";
NSString *const kWrongEmailFormatMessage = @"請輸入完整email格式";
NSString *const kNoAddressMessage = @"請輸入地址";
NSString *const kNoPhoneMessage = @"請輸入電話";

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
