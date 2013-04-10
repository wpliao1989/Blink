//
//  BKSearchOption.h
//  Blink
//
//  Created by 維平 廖 on 13/4/8.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#ifndef Blink_BKSearchOption_h
#define Blink_BKSearchOption_h

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// Define search option, List or Sort
typedef NS_ENUM(NSUInteger, BKSearchOption) {
    BKSearchOptionList = 0,
    BKSearchOptionSort = 1,
};

FOUNDATION_EXPORT NSString *const kBKOrderMethodDelivery;
FOUNDATION_EXPORT NSString *const kBKOrderMethodTakeout;

#endif
