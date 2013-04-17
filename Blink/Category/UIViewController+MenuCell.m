//
//  UIViewController+MenuCell.m
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+MenuCell.h"
#import "UIViewController+Formatter.h"
#import "BKMenuItem.h"
#import "BKMenuListCell.h"

@implementation UIViewController (MenuCell)

- (NSString *)stringForPriceFromMenuItem:(BKMenuItem *)item {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *size in item.sizeLevels) {
        [result addObject:[NSString stringWithFormat:@"%@%@", [BKMenuItem localizedStringForSize:size], [self currencyStringForPrice:[item priceForSize:size]]]];
    }
    return [result componentsJoinedByString:@", "];
}

- (void)configureMenuCell:(BKMenuListCell *)cell withMenuItem:(BKMenuItem *)item {
    
    cell.itemNameLabel.text = item.name;
    cell.priceLabel.text = [self stringForPriceFromMenuItem:item];
    
    //NSLog(@"cell.imageView.contentMode = %d", cell.imageView.contentMode);
    cell.imageView.image = [self defaultPicture];
}

@end