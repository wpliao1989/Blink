//
//  UIViewController+SharedString.h
//  Blink
//
//  Created by 維平 廖 on 13/4/23.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kNoUserNameMessage;
FOUNDATION_EXPORT NSString *const kNoAccountMessage;
FOUNDATION_EXPORT NSString *const kNoPasswordMessage;
FOUNDATION_EXPORT NSString *const kWrongPasswordMessage;
FOUNDATION_EXPORT NSString *const kPasswordNotTheSameMessage;
FOUNDATION_EXPORT NSString *const kNoEmailMessage;
FOUNDATION_EXPORT NSString *const kWrongEmailFormatMessage;
FOUNDATION_EXPORT NSString *const kNoAddressMessage;
FOUNDATION_EXPORT NSString *const kNoPhoneMessage;

@interface UIViewController (SharedString)

- (NSString *)titleForAlertView;
- (NSString *)confirmButtonTitleForAlertView;
- (NSString *)cancelButtonTitleForAlertView;
- (NSString *)deleteButtonTitleForAlertView;
- (void)showAlert:(NSString *)alertMsg;

@end
