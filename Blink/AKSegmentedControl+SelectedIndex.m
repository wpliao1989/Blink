//
//  AKSegmentedControl+SelectedIndex.m
//  Blink
//
//  Created by Wei Ping on 13/3/18.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "AKSegmentedControl+SelectedIndex.h"

@implementation AKSegmentedControl (SelectedIndex)

- (NSUInteger)firstSelectedIndex {
    return [self.selectedIndexes firstIndex];
}

@end

