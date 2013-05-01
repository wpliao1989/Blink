//
//  UIViewController+SharedString.h
//  Blink
//
//  Created by 維平 廖 on 13/4/23.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SharedString)

- (NSString *)titleForAlertView;
- (NSString *)confirmButtonTitleForAlertView;
- (NSString *)cancelButtonTitleForAlertView;
- (NSString *)deleteButtonTitleForAlertView;
- (void)showAlert:(NSString *)alertMsg;

@end
