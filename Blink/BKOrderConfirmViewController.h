//
//  BKOrderConfirmViewController.h
//  Blink
//
//  Created by Wei Ping on 13/2/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKShopInfo;

@interface BKOrderConfirmViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) BKShopInfo *shopInfo;
@end
