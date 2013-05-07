//
//  UIViewController+Additions.m
//  Blink
//
//  Created by 維平 廖 on 13/5/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

#pragma mark - Helper methods

- (CGFloat)insetHeightForView:(UIView *)view keyboardNotification:(NSNotification *)notification{
    NSDictionary* info = [notification userInfo];
    
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect kbFrameConverted = [view convertRect:kbFrame fromView:nil];
    //CGSize kbSize = kbFrameConverted.size;
    
    CGFloat scrollViewBottomY = CGRectGetMaxY(view.bounds);
    CGFloat kbOriginY = CGRectGetMinY(kbFrameConverted);
    CGFloat insetHeight = scrollViewBottomY - kbOriginY;
    
    return insetHeight;
}

@end
