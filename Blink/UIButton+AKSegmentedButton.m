//
//  UIButton+AKSegmentedButton.m
//  Blink
//
//  Created by 維平 廖 on 13/3/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIButton+AKSegmentedButton.h"

@implementation UIButton (AKSegmentedButton)

+ (UIButton *)buttonForNormalImage:(UIImage *)normalImage pressedImage:(UIImage *)pressedImage {
    UIButton *button = [[UIButton alloc] init];
    
    //    [buttonSocial setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [button changeButtonImage:normalImage pressedImage:pressedImage];
    
    return button;
}

- (void)changeButtonImage:(UIImage *)normalImage pressedImage:(UIImage *)pressedImage {
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self setBackgroundImage:pressedImage forState:UIControlStateSelected];
    [self setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:pressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];

}

- (void)changeTextColor:(UIColor *)normalColor highlightedColor:(UIColor *)hilightedColor {
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:hilightedColor forState:UIControlStateSelected];
    [self setTitleColor:hilightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:hilightedColor forState:UIControlStateHighlighted|UIControlStateSelected];
}

@end
