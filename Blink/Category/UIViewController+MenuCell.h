//
//  UIViewController+MenuCell.h
//  Blink
//
//  Created by 維平 廖 on 13/4/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKMenuItem;
@class BKMenuListCell;

@interface UIViewController (MenuCell)

- (NSString *)stringForPriceFromMenuItem:(BKMenuItem *)item;
- (void)configureMenuCell:(BKMenuListCell *)cell withMenuItem:(BKMenuItem *)item;

@end
