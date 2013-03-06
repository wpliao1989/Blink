//
//  BKOrderConfirmViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderConfirmViewController.h"
#import "BKShopDetailViewController.h"
#import "BKOrderManager.h"
#import "BKOrderContent.h"
#import "BKShopInfo.h"
#import "BKShopInfoManager.h"
#import "BKAccountManager.h"

@interface BKOrderConfirmViewController ()

- (IBAction)orderConfirmButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceTypeLabel;

@property (strong, nonatomic) BKShopInfo *shopInfo;

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;

- (NSString *)currencyStringForPrice:(NSNumber *)price;
- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice;

- (void)initUserInfos;

@end

@implementation BKOrderConfirmViewController

@synthesize shopInfo = _shopInfo;

@synthesize userToken = _userToken;
@synthesize userName = _userName;
@synthesize userPhone = _userPhone;
@synthesize userAddress = _userAddress;

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameLabel.text = userName;
}

- (void)setUserPhone:(NSString *)userPhone {
    _userPhone = userPhone;
    self.userPhoneLabel.text = userPhone;
}

- (void)setUserAddress:(NSString *)userAddress {
    _userAddress = userAddress;
}

- (BKShopInfo *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
}

- (void)initUserInfos {
    self.userToken = [BKAccountManager sharedBKAccountManager].userToken;
    self.userName = [BKAccountManager sharedBKAccountManager].userName;
    self.userPhone = [BKAccountManager sharedBKAccountManager].userPhone;
//    self.userAddress = [BKAccountManager sharedBKAccountManager].userAddress;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.totalPriceLabel.text = [self stringForTotalPrice:[[BKOrderManager sharedBKOrderManager] totalPrice]];
    self.shopNameLabel.text = [[BKOrderManager sharedBKOrderManager] shopName];
    [self initUserInfos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility methods

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
    static NSString *preString = @"總金額: ";
    static NSString *postString = @"元";
    NSString *result = [[preString stringByAppendingString:[totalPrice stringValue]] stringByAppendingString:postString];
    return result;
}

#pragma mark - Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BKOrderManager sharedBKOrderManager] numberOfOrderContentsForShopInfo:self.shopInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    UILabel *basePrice = (UILabel *)[cell viewWithTag:2];    
    UILabel *quantity = (UILabel *)[cell viewWithTag:3];
    UILabel *price = (UILabel *)[cell viewWithTag:4];
    
    BKOrderContent *orderContent = [[BKOrderManager sharedBKOrderManager] orderContentAtIndex:indexPath.row];
    name.text = orderContent.name;
    basePrice.text = [orderContent.basePrice stringValue];
    quantity.text = [orderContent.quantity stringValue];
    price.text = [self currencyStringForPrice:orderContent.priceValue];
    
    return cell;
}

- (IBAction)orderConfirmButtonPressed:(id)sender {
#warning Poping method should be changed to popToViewController
    [[BKOrderManager sharedBKOrderManager] setUserToken:self.userToken userName:self.userName userPhone:self.userPhone userAddress:self.userAddress];
    [[BKOrderManager sharedBKOrderManager] sendOrderWithCompleteHandler:^(BOOL success) {
        if (success) {
            UIViewController *destinationVC = [self.navigationController.viewControllers objectAtIndex:2];
            if ([destinationVC isKindOfClass:[BKShopDetailViewController class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }
        }
        else {
            NSLog(@"Warning: order failed!");
        }
    }];   
}
@end
