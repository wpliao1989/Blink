//
//  UIViewController+UserOrderListCell.m
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+UserOrderListCell.h"
#import "BKUserOrderListCell.h"
#import "BKOrderForReceiving.h"
#import "UIViewController+Formatter.h"

@implementation UIViewController (UserOrderListCell)

- (void)configureUserOrderListCell:(BKUserOrderListCell *)cell withOrder:(BKOrderForReceiving *)order {
    UIImage *backgroundImage = [UIImage imageNamed:@"list"];
    UIImage *pressImage = [UIImage imageNamed:@"list_press"];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:pressImage];
    
    cell.totalPriceLabel.text = [self stringForTotalPrice:order.totalPrice];
    cell.shopNameLabel.text = order.shopName;
    
    cell.statusImageView.image = nil;
    
    if ([order.status isEqualToString:BKOrderItemStatusSent]) {
        cell.statusImageView.image = [UIImage imageNamed:@"circle_ok"];
    }
    else if ([order.status isEqualToString:BKOrderItemStatusProccessed]) {
        cell.statusImageView.image = [UIImage imageNamed:@"circle_do"];
    }
    else if ([order.status isEqualToString:BKOrderItemStatusDelivered]) {
        cell.statusImageView.image = [UIImage imageNamed:@"circle_go"];
    }
    else if ([order.status isEqualToString:BKOrderItemStatusFinished]) {
        cell.statusImageView.image = [UIImage imageNamed:@"circle"];
    }
    else {
        assert(true);
    }
}

@end
