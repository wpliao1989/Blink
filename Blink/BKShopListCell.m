//
//  BKShopListCell.m
//  Blink
//
//  Created by Wei Ping on 13/3/13.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopListCell.h"

@implementation BKShopListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, 10, 60, 60);
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    NSLog(@"touch!");
////    NSLog(@"self.subviews: %@", self.subviews);
//    for (UIView* view in self.subviews) {
//        NSLog(@"view: %@", [view class]);
//    }
//    
//    for (UIView *view in self.contentView.subviews) {
//        NSLog(@"con view:%@", [view class]);
//    }
//    NSLog(@"label: %@", [self viewWithTag:1]);
//}

@end
