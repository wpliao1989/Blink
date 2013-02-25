//
//  BKMakeOrderViewController.h
//  Blink
//
//  Created by Wei Ping on 13/2/4.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKMakeOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *menu;

@end
