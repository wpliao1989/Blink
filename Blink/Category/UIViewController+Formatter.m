//
//  UIViewController+Formatter.m
//  Blink
//
//  Created by 維平 廖 on 13/4/10.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+Formatter.h"
#import "NSNumber+NullNumber.h"

@implementation UIViewController (Formatter)

- (NSString *)currencyStringForPrice:(NSNumber *)price {
    static NSNumberFormatter *currencyFormatter;
    
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setPositiveFormat:@"¤#,###"];
        NSLocale *twLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"];
        [currencyFormatter setLocale:twLocale];
        [currencyFormatter setCurrencySymbol:@"$"];
        //        NSLog(@"positive format: %@", [currencyFormatter positiveFormat]);
    }
    
    return [currencyFormatter stringFromNumber:price];
}

- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice {
    //    static NSString *preString = @"總金額: ";
    static NSString *postString = @"元";
    NSString *result = [NSString stringWithFormat:@"%@%@", [totalPrice stringValue], postString];
    return result;
}

- (UIImage *)defaultPicture {
    static UIImage *pic;
    if (pic == nil) {
        pic = [UIImage imageNamed:@"picture"];
    }
    return pic;
}

@end




