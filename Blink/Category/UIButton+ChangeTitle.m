//
//  UIButton+ChangeTitle.m
//  BlinkIPad
//
//  Created by 維平 廖 on 13/3/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIButton+ChangeTitle.h"

@implementation UIButton (ChangeTitle)

- (void)changeTitleTo:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
//    [self setTitle:@"" forState:UIControlStateDisabled];
}

- (void)changeTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

@end
