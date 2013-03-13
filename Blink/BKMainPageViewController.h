;//
//  mainPageViewController.h
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKMainPageViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end
