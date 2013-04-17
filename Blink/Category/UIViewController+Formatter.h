//
//  UIViewController+Formatter.h
//  Blink
//
//  Created by 維平 廖 on 13/4/10.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Formatter)

- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice;
- (NSString *)currencyStringForPrice:(NSNumber *)price;
- (UIImage *)defaultPicture;

@end

