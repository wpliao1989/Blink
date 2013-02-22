//
//  BKTestCenter.m
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKTestCenter.h"
#import "BKShopInfo.h"
#import "BKMenuItem.h"
#import "BKOrderManager.h"
#import "BKOrderContent.h"

#define menu(dictionary) [[BKMenuItem alloc] initWithData:dictionary]

@implementation BKTestCenter

+ (NSArray *)testShopInfos {   
    
    NSDictionary *shop1Info = @{kBKShopName: @"王品",
                                kBKShopMenu: @[menu(@{kBKMenuName:@"好"}), menu(@{kBKMenuName:@"吃"}), menu(@{kBKMenuName:@"牛"}), menu(@{kBKMenuName:@"排"})],
                                kBKShopPhone: @"04-00000000",
                                kBKShopAddress: @"台中市0號",
                                kBKShopOpenHour: @"10:00~21:00",
                                kBKShopDescription: @"王品的優惠"};
    
    NSDictionary *shop2Info = @{kBKShopName: @"舒果",
                                kBKShopMenu: @[menu(@{kBKMenuName:@"素"}), menu(@{kBKMenuName:@"食"}), menu(@{kBKMenuName:@"新"}), menu(@{kBKMenuName:@"鮮"})],
                                kBKShopPhone: @"04-11111111",
                                kBKShopAddress: @"台中市1號",
                                kBKShopOpenHour: @"10:10~21:10",
                                kBKShopDescription: @"舒果的優惠"};
    
    NSDictionary *shop3Info = @{kBKShopName: @"原燒",
                                kBKShopMenu: @[menu(@{kBKMenuName:@"極"}), menu(@{kBKMenuName:@"品"}), menu(@{kBKMenuName:@"燒"}), menu(@{kBKMenuName:@"肉"})],
                                kBKShopPhone: @"04-22222222",
                                kBKShopAddress: @"台中市2號",
                                kBKShopOpenHour: @"10:20~21:20",
                                kBKShopDescription: @"原燒的優惠"};
    
    NSArray *testShopInfos = [NSArray arrayWithObjects:shop1Info,shop2Info,shop3Info,nil];
    return testShopInfos;
}

+ (NSArray *)testFavoriteShopInfos {
    NSDictionary *shop1Info = @{kBKShopName: @"50藍",
                                kBKShopMenu: @[menu(@{kBKMenuName:@"飲"}), menu(@{kBKMenuName:@"料"}), menu(@{kBKMenuName:@"好"}), menu(@{kBKMenuName:@"喝"})],
                                kBKShopPhone: @"04-00000000",
                                kBKShopAddress: @"台中市0號",
                                kBKShopOpenHour: @"10:00~21:00",
                                kBKShopDescription: @"50藍的優惠"};
    
    NSDictionary *shop2Info = @{kBKShopName: @"成時",
                                kBKShopMenu: @[menu(@{kBKMenuName:@"創"}), menu(@{kBKMenuName:@"意"}), menu(@{kBKMenuName:@"料"}), menu(@{kBKMenuName:@"理"})],
                                kBKShopPhone: @"04-11111111",
                                kBKShopAddress: @"台中市1號",
                                kBKShopOpenHour: @"10:10~21:10",
                                kBKShopDescription: @"成時的優惠"};
    
    NSDictionary *shop3Info = @{kBKShopName: @"雞排店",
                                kBKShopMenu: @[menu(@{kBKMenuName:@"大"}), menu(@{kBKMenuName:@"小"}), menu(@{kBKMenuName:@"雞"}), menu(@{kBKMenuName:@"排"})],
                                kBKShopPhone: @"04-22222222",
                                kBKShopAddress: @"台中市2號",
                                kBKShopOpenHour: @"10:20~21:20",
                                kBKShopDescription: @"雞排店的優惠"};
    
    BKShopInfo *shop1 = [[BKShopInfo alloc] initWithData:shop1Info];
    BKShopInfo *shop2 = [[BKShopInfo alloc] initWithData:shop2Info];
    BKShopInfo *shop3 = [[BKShopInfo alloc] initWithData:shop3Info];
    
    NSArray *testShopInfos = [NSArray arrayWithObjects:shop1,shop2,shop3,nil];
    return testShopInfos;
}

+ (NSDictionary *)testOrder {
    NSArray *testContent = @[@{kBKOrderContentUUID: @1000,
                               kBKOrderContentName: @"123",
                               kBKOrderContentSize: @"big",
                               kBKOrderContentIce: @"normal",
                               kBKOrderContentSweetness: @"half",
                               kBKOrderContentQuantity: @10}];
    
    NSDictionary *testDict = @{kBKOrderUserToken: @"123",
                               kBKOrderShopID: @"123",
                               kBKOrderRecordTime: @"123",
                               kBKOrderUserAddress: @"123",
                               kBKOrderUserPhone: @"123",
                               kBKOrderContent: testContent};
    return testDict;
}

+ (void)testPrint {
    NSArray *testArray = @[@"123", @10, [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    NSDictionary *testDi = @{@"1": @"123", @"2": @10, @"3": [NSNumber numberWithBool:YES], @"4": [NSNumber numberWithBool:NO]};
    
    NSLog(@"testArray = %@", testArray);
    NSLog(@"testDict = %@", testDi);
}

@end
