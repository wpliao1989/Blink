//
//  BKTestCenter.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKTestCenter.h"
#import "BKShopInfo.h"

@implementation BKTestCenter

+ (NSArray *)testShopInfos {   
    NSDictionary *shop1Info = @{kBKShopName: @"王品", kBKShopMenu: @[@"好", @"吃", @"牛", @"排"], kBKShopPhone: @"04-00000000", kBKShopAddress: @"台中市0號", kBKShopOpenHour: @"10:00~21:00"};
    NSDictionary *shop2Info = @{kBKShopName: @"舒果", kBKShopMenu: @[@"素", @"食", @"新", @"鮮"], kBKShopPhone: @"04-11111111", kBKShopAddress: @"台中市1號", kBKShopOpenHour: @"10:10~21:10"};
    NSDictionary *shop3Info = @{kBKShopName: @"原燒", kBKShopMenu: @[@"極", @"品", @"燒", @"肉"], kBKShopPhone: @"04-22222222", kBKShopAddress: @"台中市2號", kBKShopOpenHour: @"10:20~21:20"};
    
    NSArray *testShopInfos = [NSArray arrayWithObjects:shop1Info,shop2Info,shop3Info,nil];
    return testShopInfos;
}

+ (NSArray *)testFavoriteShopInfos {
    NSDictionary *shop1Info = @{kBKShopName: @"50藍", kBKShopMenu: @[@"飲", @"料", @"好", @"喝"], kBKShopPhone: @"04-00000000", kBKShopAddress: @"台中市0號", kBKShopOpenHour: @"10:00~21:00"};
    NSDictionary *shop2Info = @{kBKShopName: @"成時", kBKShopMenu: @[@"創", @"意", @"料", @"理"], kBKShopPhone: @"04-11111111", kBKShopAddress: @"台中市1號", kBKShopOpenHour: @"10:10~21:10"};
    NSDictionary *shop3Info = @{kBKShopName: @"雞排店", kBKShopMenu: @[@"大", @"小", @"雞", @"排"], kBKShopPhone: @"04-22222222", kBKShopAddress: @"台中市2號", kBKShopOpenHour: @"10:20~21:20"};
    
    BKShopInfo *shop1 = [[BKShopInfo alloc] initWithData:shop1Info];
    BKShopInfo *shop2 = [[BKShopInfo alloc] initWithData:shop2Info];
    BKShopInfo *shop3 = [[BKShopInfo alloc] initWithData:shop3Info];
    
    NSArray *testShopInfos = [NSArray arrayWithObjects:shop1,shop2,shop3,nil];
    return testShopInfos;
}

@end
