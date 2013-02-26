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
#import "BKOrder.h"

#define menu(dictionary) [[BKMenuItem alloc] initWithData:dictionary]

@implementation BKTestCenter

+ (NSArray *)testShopInfos {   
    NSDictionary *shop11menu = @{kBKMenuName:@"喝的東西",
                                   kBKMenuIce: @[@"low", @"normal"],
                                   kBKMenuSweetness: @[@"half"]};
    
    NSDictionary *shop1Info = @{kBKShopName: @"王品",
                                kBKShopMenu: @[menu(shop11menu), menu(@{kBKMenuName:@"吃的東西"}), menu(@{kBKMenuName:@"牛"}), menu(@{kBKMenuName:@"排"})],
                                kBKShopPhone: @"04-00000000",
                                kBKShopAddress: @"台中市0號",
                                kBKShopOpenHour: @"10:00~21:00",
                                kBKShopDescription: @"王品的優惠"};
    
    NSDictionary *shop2Info = @{kBKShopName: @"舒果",
//                                kBKShopMenu: @[menu(@{kBKMenuName:@"素"}), menu(@{kBKMenuName:@"食"}), menu(@{kBKMenuName:@"新"}), menu(@{kBKMenuName:@"鮮"})],
                                kBKShopMenu: @[],
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

+ (BKOrder *)testOrder {
    NSArray *testContent = @[@{kBKOrderContentUUID: @1000,
                               kBKOrderContentName: @"123",
                               kBKOrderContentSize: @"big",
                               kBKOrderContentIce: @"normal",
                               kBKOrderContentSweetness: @"half",
                               kBKOrderContentQuantity: @10}];
    
    BKOrder *testOrder = [[BKOrder alloc] init];
    testOrder.userToken = @"test";
    testOrder.shopID = @"123";
    testOrder.recordTime = @"123";
    testOrder.address = @"123";
    testOrder.phone = @"123";
    testOrder.content = [testContent mutableCopy];
    testOrder.note = @"123";
    
//    NSLog(@"testOrder.content is valid json object %d", [NSJSONSerialization isValidJSONObject:testOrder.content]);

    return testOrder;
}

static NSInteger quantity = 1;
+ (BKOrderContent *)testOrderContent {    
    BKOrderContent *testOC = [[BKOrderContent alloc] init];
    testOC.name = @"test a reeeeeeeeaaaaaaally long name";
    testOC.UUID = [NSNumber numberWithInt:1000];
    testOC.ice = @"noneqweqweqwe";
    testOC.size = @"bigqweqweqwe";
    testOC.sweetness = @"normalqeqweqwe";
    testOC.quantity = [NSNumber numberWithInt:quantity];
    quantity = quantity + 1;
    
    testOC.basePrice = @"15000";
    
    return testOC;
}

+ (void)testPrint {
    NSArray *testArray = @[@"123", @10, [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    NSDictionary *testDi = @{@"1": @"123", @"2": @10, @"3": [NSNumber numberWithBool:YES], @"4": [NSNumber numberWithBool:NO]};
    
    NSLog(@"testArray = %@", testArray);
    NSLog(@"testDict = %@", testDi);
}

@end
