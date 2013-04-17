//
//  UIViewController+UserOrderListCell.h
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKUserOrderListCell;
@class BKOrderForReceiving;

@interface UIViewController (UserOrderListCell)

- (void)configureUserOrderListCell:(BKUserOrderListCell *)cell withOrder:(BKOrderForReceiving *)order;

@end
