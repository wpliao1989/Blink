//
//  BKShopListCell.h
//  Blink
//
//  Created by Wei Ping on 13/3/13.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BKShopListCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *scoreImageViews;
@property (strong, nonatomic) IBOutlet UILabel *commerceTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceAndDistanceLabel;

@end
