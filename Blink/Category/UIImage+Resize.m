//
//  UIImage+Resize.m
//  BlinkIPad
//
//  Created by Wei Ping on 13/3/26.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithResizeCapInset:(UIEdgeInsets)insets size:(CGSize)size {
    UIImage *image = [self resizableImageWithCapInsets:insets];
    image = [UIImage imageWithImage:image scaledToSize:size];
    return image;
}

@end
