//
//  BKNotifier.h
//  Blink
//
//  Created by 維平 廖 on 13/5/6.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "JSNotifier.h"

typedef NS_ENUM(NSUInteger, BKNotifierAnimation) {
    BKNotifierAnimationShowFromBottom = 0,
    BKNotifierAnimationShowFromTop = 1
};

@interface BKNotifier : JSNotifier

- (id)initWithTitle:(NSString *)title inView:(UIView *)parentView;

- (void)showAnimation:(BKNotifierAnimation)animationType animated:(BOOL)animated;
- (void)hideIn:(double)seconds animated:(BOOL)animated;

@end
