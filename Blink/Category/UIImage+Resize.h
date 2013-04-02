//
//  UIImage+Resize.h
//  BlinkIPad
//
//  Created by Wei Ping on 13/3/26.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
- (UIImage *)imageWithResizeCapInset:(UIEdgeInsets)insets size:(CGSize)size;

@end
