//
//  BKMakeOrderViewController.h
//  Blink
//
//  Created by Wei Ping on 13/2/4.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKShopInfo;

@interface BKMakeOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *shopID;

// This is made public specific for NoteViewController
//- (NSString *)orderExistsMessage;

@end
