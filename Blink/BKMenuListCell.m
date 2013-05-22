//
//  BKMenuListCell.m
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuListCell.h"

@implementation BKMenuListCell

- (void)layoutSubviews {
    [super layoutSubviews];
#warning Changes made here will affect both iPhone and iPad
    CGFloat topMargin = self.bounds.size.height * 0.1;
    CGFloat leftMargin = 10;
    CGFloat height = self.bounds.size.height * 0.8;
    CGFloat width = height;
    
    self.imageView.frame = CGRectMake(leftMargin, topMargin, width, height);
//    float limgW =  self.imageView.image.size.width;
//    if(limgW > 0) {
//        self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
//        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
//    }
}

@end
