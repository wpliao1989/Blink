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
    UIImage *buttonNormalImage = normalImage;
    UIImage *buttonPressedImage = pressedImage;
    
    //    [buttonSocial setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [button setImage:buttonNormalImage forState:UIControlStateNormal];
    [button setImage:buttonPressedImage forState:UIControlStateSelected];
    [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setImage:buttonPressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    return button;
}

@end
