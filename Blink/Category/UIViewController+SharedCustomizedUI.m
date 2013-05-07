//
//  UIViewController+SharedCustomizedUI.m
//  Blink
//
//  Created by 維平 廖 on 13/4/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+SharedCustomizedUI.h"

@implementation UIViewController (SharedCustomizedUI)

- (UIColor *)viewBackgoundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]];
}

- (UIImage *)titleImage {
    return [[UIImage imageNamed:@"a1"] resizableImageWithCapInsets:UIEdgeInsetsMake(175, 158, 180, 158)];
}

- (UIImage *)resizableListImage {
    return [[UIImage imageNamed:@"list_try"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 14, 67, 20)];
}

@end
