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
#import "BKOrderContentForSending.h"
#import "BKOrderForSending.h"
#import "NSObject+NullObject.h"
#import "NSMutableArray+Sort.h"

@implementation BKTestCenter

+ (NSArray *)testShopInfos {   
    NSDictionary *shop11menu = @{kBKMenuUUID:@1000,
                                 kBKMenuName:@"喝的東西",
                                   kBKMenuIce: @[@"正常", @"七分", @"一半", @"三分", @"去冰", @"熱"],
                                   kBKMenuSweetness: @[@"正常", @"七分", @"一半", @"三分", @"無糖"]};
    NSDictionary *shop12menu = @{kBKMenuUUID:@2000,
                                 kBKMenuName:@"吃的東西"
                                 
                                 };
    
    NSDictionary *shop1Info = @{kBKSShopID: @"1000",
                                kBKShopName: @"王品",
                                kBKShopMenu: @[shop11menu, shop12menu, @{kBKMenuName:@"牛"}, @{kBKMenuName:@"排"}],
                                kBKShopPhone: @"04-00000000",
                                kBKShopAddress: @"台中市0號",
                                kBKShopBusinessHour: @"10:00~21:00",
                                kBKShopDescription: @"王品的優惠"};
    
    NSDictionary *shop2Info = @{kBKSShopID: @"2000",
                                kBKShopName: @"舒果",
//                                kBKShopMenu: @[@{kBKMenuName:@"素"}, @{kBKMenuName:@"食"}, @{kBKMenuName:@"新"}, @{kBKMenuName:@"鮮"}],
                                kBKShopMenu: @[],
                                kBKShopPhone: @"04-11111111",
                                kBKShopAddress: @"台中市1號",
                                kBKShopBusinessHour: @"10:10~21:10",
                                kBKShopDescription: @"舒果的優惠"};
    
    NSDictionary *shop3Info = @{kBKSShopID: @"3000",
                                kBKShopName: @"原燒",
                                kBKShopMenu: @[@{kBKMenuName:@"極"}, @{kBKMenuName:@"品"}, @{kBKMenuName:@"燒"}, @{kBKMenuName:@"肉"}],
                                kBKShopPhone: @"04-22222222",
                                kBKShopAddress: @"台中市2號",
                                kBKShopBusinessHour: @"10:20~21:20",
                                kBKShopDescription: @"原燒的優惠"};
    
    NSArray *testShopInfos = [NSArray arrayWithObjects:shop1Info,shop2Info,shop3Info,nil];
    return testShopInfos;
}

+ (NSArray *)testFavoriteShops {
    NSDictionary *shop1Info = @{kBKSShopID: @"4000",
                                kBKShopName: @"50藍",
                                kBKShopMenu: @[@{kBKMenuName:@"飲"}, @{kBKMenuName:@"料"}, @{kBKMenuName:@"好"}, @{kBKMenuName:@"喝"}],
                                kBKShopPhone: @"04-00000000",
                                kBKShopAddress: @"台中市0號",
                                kBKShopBusinessHour: @"10:00~21:00",
                                kBKShopDescription: @"50藍的優惠"};
    
    NSDictionary *shop2Info = @{
                                kBKSShopID: @"5000",
                                kBKShopName: @"成時",
                                kBKShopMenu: @[@{kBKMenuName:@"創"}, @{kBKMenuName:@"意"}, @{kBKMenuName:@"料"}, @{kBKMenuName:@"理"}],
                                kBKShopPhone: @"04-11111111",
                                kBKShopAddress: @"台中市1號",
                                kBKShopBusinessHour: @"10:10~21:10",
                                kBKShopDescription: @"成時的優惠"};
    
    NSDictionary *shop3Info = @{
                                kBKSShopID: @"6000",
                                kBKShopName: @"雞排店",
                                kBKShopMenu: @[@{kBKMenuName:@"大"}, @{kBKMenuName:@"小"}, @{kBKMenuName:@"雞"}, @{kBKMenuName:@"排"}],
                                kBKShopPhone: @"04-22222222",
                                kBKShopAddress: @"台中市2號",
                                kBKShopBusinessHour: @"10:20~21:20",
                                kBKShopDescription: @"雞排店的優惠"};
    
//    BKShopInfo *shop1 = [[BKShopInfo alloc] initWithData:shop1Info];
//    BKShopInfo *shop2 = [[BKShopInfo alloc] initWithData:shop2Info];
//    BKShopInfo *shop3 = [[BKShopInfo alloc] initWithData:shop3Info];
    
    NSArray *testShopInfos = [NSArray arrayWithObjects:shop1Info,shop2Info,shop3Info,nil];
    return testShopInfos;
}

+ (BKOrderForSending *)testOrder {
    NSArray *testContent = @[@{kBKOrderContentUUID: @1000,
                               kBKOrderContentName: @"123",
                               kBKOrderContentSize: @"big",
                               kBKOrderContentIce: @"normal",
                               kBKOrderContentSweetness: @"half",
                               kBKOrderContentQuantity: @10}];
    
    BKOrderForSending *testOrder = [[BKOrderForSending alloc] init];
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
+ (BKOrderContentForSending *)testOrderContent {    
    BKOrderContentForSending *testOC = [[BKOrderContentForSending alloc] init];
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

+ (void)testMethods {
    NSLog(@"Testing..");
//    NSNumber *testNumber = @(1);
//    NSLog(@"testNumber: %d", [testNumber intValue]);
//    NSString *large = @"large";
//    NSString *medium = @"medium";
//    NSString *small = @"small";
//    
//    NSArray *sortOrder = @[medium, large, small];
//    NSDictionary *price = @{small:@"1", large:@"2", medium:@"3", @"none":@"4"};
//    NSMutableArray *allKeys = [[price allKeys] mutableCopy];
//    
//    NSLog(@"All keys before sorting: %@", allKeys);
//    
//    [allKeys sortUsingAnotherArray:sortOrder];
//    
//    NSLog(@"All keys after sorting: %@", allKeys);
    
//    NSDictionary *test = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"APICodeTable" withExtension:@"plist"]];
//    NSLog(@"test = %@", test);
    NSDate *now = [NSDate date];
    NSNumber *unixTime = [NSNumber numberWithDouble:[now timeIntervalSince1970]];
    NSLog(@"now:%@, unix time:%@", now, unixTime);
}

@end
