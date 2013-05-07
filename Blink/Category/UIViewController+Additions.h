//
//  UIViewController+Additions.h
//  Blink
//
//  Created by 維平 廖 on 13/5/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

// Helper methods
- (CGFloat)insetHeightForView:(UIView *)view keyboardNotification:(NSNotification *)notification;

@end
