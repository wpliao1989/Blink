//
//  UIButton+AKSegmentedButton.h
//  Blink
//
//  Created by 維平 廖 on 13/3/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AKSegmentedButton)

+ (UIButton *)buttonForNormalImage:(UIImage *)normalImage pressedImage:(UIImage *)pressedImage;
- (void)changeButtonImage:(UIImage *)normalImage pressedImage:(UIImage *)pressedImage;
- (void)changeTextColor:(UIColor *)normalColor highlightedColor:(UIColor *)hilightedColor;

@end
