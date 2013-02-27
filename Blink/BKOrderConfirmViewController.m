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
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userPhone;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *serviceType;

@property (strong, nonatomic) BKShopInfo *shopInfo;

- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice;

@end

@implementation BKOrderConfirmViewController

@synthesize shopInfo = _shopInfo;

- (BKShopInfo *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
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
    self.totalPrice.text = [self stringForTotalPrice:[[BKOrderManager sharedBKOrderManager] totalPrice]];
    self.shopName.text = [[BKOrderManager sharedBKOrderManager] shopName];
    self.userName.text = [BKAccountManager sharedBKAccountManager].userName;
    self.userPhone.text = [BKAccountManager sharedBKAccountManager].userPhone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    basePrice.text = orderContent.basePrice;
    quantity.text = [orderContent.quantity stringValue];
    price.text = orderContent.price;
    
    return cell;
}

- (IBAction)orderConfirmButtonPressed:(id)sender {
#warning Poping method should be changed to popToViewController
    [[BKOrderManager sharedBKOrderManager] sendOrder];
    
    UIViewController *destinationVC = [self.navigationController.viewControllers objectAtIndex:2];
    if ([destinationVC isKindOfClass:[BKShopDetailViewController class]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}
@end
