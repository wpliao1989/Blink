//
//  BKShopDetailViewController.h
//  Blink
//
//  Created by Wei Ping on 13/2/1.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BKScrollableViewController.h"

@class BKShopInfoForUser;

@interface BKShopDetailViewController : BKScrollableViewController<UIActionSheetDelegate>

@property (strong, nonatomic) NSString *shopID;
// This home button is for menu view controller
@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeButton;

@end
