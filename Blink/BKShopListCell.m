//
//  BKShopListCell.m
//  Blink
//
//  Created by Wei Ping on 13/3/13.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopListCell.h"

@implementation BKShopListCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, 10, 60, 60);
    //self.imageView.layer.cornerRadius = 8.0f;
    //[self.imageView.layer setMasksToBounds:YES];
}

@end
