//
//  BKUserOrderListCell.h
//  Blink
//
//  Created by 維平 廖 on 13/4/11.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKUserOrderListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end
