//
//  loginViewController.h
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol BKRegisterViewControllerDelegate;
@protocol MBProgressHUDDelegate;

@interface BKLoginViewController : UIViewController<MBProgressHUDDelegate, UITextFieldDelegate>

@end
