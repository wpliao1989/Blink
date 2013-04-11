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
#import "BKOrderContentForSending.h"
#import "BKShopInfo.h"
#import "BKShopInfoManager.h"
#import "BKAccountManager.h"
#import "UIViewController+BKBaseViewController.h"
#import "BKMenuItem.h"
#import "UIViewController+Formatter.h"

@interface BKOrderConfirmViewController ()

- (IBAction)orderConfirmButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *backgrond;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) BKShopInfo *shopInfo;

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;

//@property (strong, nonatomic) MBProgressHUD *HUD;

- (NSString *)stringForSize:(NSString *)size quantity:(NSNumber *)quantity ice:(NSString *)ice sweetness:(NSString *)sweetness;

- (void)initUserInfos;
- (NSString *)stringFromDate:(NSDate *)date;

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
    self.userAddressLabel.text = userAddress;
}

- (BKShopInfo *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
}

- (void)initUserInfos {
    self.userToken = [BKAccountManager sharedBKAccountManager].userToken;
    self.userName = [BKAccountManager sharedBKAccountManager].userName;
    self.userPhone = [BKAccountManager sharedBKAccountManager].userPhone;
    self.userAddress = [BKAccountManager sharedBKAccountManager].userAddress;
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
    [self initUserInfos];
    NSLog(@"date: %@", [BKOrderManager sharedBKOrderManager].recordTime);
    
    self.timeLabel.text = [self stringFromDate:[BKOrderManager sharedBKOrderManager].recordTime];
    self.totalPriceLabel.text = [self stringForTotalPrice:[[BKOrderManager sharedBKOrderManager] totalPriceForShop:self.shopInfo]];
    self.shopNameLabel.text = [[BKOrderManager sharedBKOrderManager] shopName];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
    [self.backgrond setImage:[[UIImage imageNamed:@"list_try"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 14, 67, 20)]];        
}

#pragma mark - Utility methods

- (NSString *)stringFromDate:(NSDate *)date {
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/M/d HH:mm"];
        //        [formatter setDateStyle:NSDateFormatterShortStyle];
        //        [formatter setTimeStyle:NSDateFormatterShortStyle];
        //        NSLog(@"formatter string: %@", formatter.dateFormat);
    }
    return [formatter stringFromDate:date];
}

- (NSString *)stringForSize:(NSString *)size quantity:(NSNumber *)quantity ice:(NSString *)ice sweetness:(NSString *)sweetness {
    NSMutableArray *strings = [NSMutableArray array];
    if (ice != nil) {
        [strings addObject:[BKMenuItem localizedStringForIce:ice]];
    }
    if (sweetness != nil) {
        [strings addObject:[BKMenuItem localizedStringForSweetness:sweetness]];
    }
    
    NSString *iceAndSweetness = strings.count > 0 ? [NSString stringWithFormat:@"(%@)", [strings componentsJoinedByString:@"、"]] : @"";
    
    return [NSString stringWithFormat:@"%@ %@ %@", [quantity stringValue], [BKMenuItem localizedStringForSize:size], iceAndSweetness];
}

#pragma mark - Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BKOrderManager sharedBKOrderManager] numberOfOrderContentsForShopInfo:self.shopInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    UILabel *basePrice = (UILabel *)[cell viewWithTag:2];    
    UILabel *quantity = (UILabel *)[cell viewWithTag:3];
    UILabel *price = (UILabel *)[cell viewWithTag:4];
    UILabel *sizeQuantityIceSweet = (UILabel *)[cell viewWithTag:5];
//    UILabel *sweetness = (UILabel *)[cell viewWithTag:5];
//    UILabel *ice = (UILabel *)[cell viewWithTag:6];
    
    BKOrderContentForSending *orderContent = [[BKOrderManager sharedBKOrderManager] orderContentAtIndex:indexPath.row];
    name.text = orderContent.name;
    basePrice.text = [orderContent.basePrice stringValue];
    quantity.text = [orderContent.quantity stringValue];
    price.text = [self currencyStringForPrice:orderContent.priceValue];
    sizeQuantityIceSweet.text = [self stringForSize:orderContent.size quantity:orderContent.quantity ice:orderContent.ice sweetness:orderContent.sweetness];
//    sweetness.text = orderContent.sweetness;
//    ice.text = orderContent.ice;
    
    return cell;
}

#pragma mark - Send order

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    [[BKOrderManager sharedBKOrderManager] sendOrderWithCompleteHandler:^(BOOL success, NSError *error) {
        if (success) {
            [[BKOrderManager sharedBKOrderManager] clear];
            successBlock(@"訂購成功!");
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UIViewController *destinationVC = [self.navigationController.viewControllers objectAtIndex:2];
                if ([destinationVC isKindOfClass:[BKShopDetailViewController class]]) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                }
            });
        }
        else {
            failBlock(error);
        }        
    }];
}

- (IBAction)orderConfirmButtonPressed:(id)sender {
#warning Poping method should be changed to popToViewController
    [[BKOrderManager sharedBKOrderManager] setUserToken:self.userToken userName:self.userName userPhone:self.userPhone userAddress:self.userAddress];
    [self showHUDViewWithMessage:@"送出中..."];
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:self.HUD];
//    self.HUD.delegate = self;
//    self.HUD.labelText = @"送出中...";
//    [self.HUD show:YES];
//    
//    [[BKOrderManager sharedBKOrderManager] sendOrderWithCompleteHandler:^(BOOL success, NSError *error) {
//        if (success) {
//            self.HUD.mode = MBProgressHUDModeText;
//            self.HUD.labelText = @"訂購成功!";
//            [[BKOrderManager sharedBKOrderManager] clear];
//            double delayInSeconds = 1.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self.HUD hide:YES];
//                UIViewController *destinationVC = [self.navigationController.viewControllers objectAtIndex:2];
//                if ([destinationVC isKindOfClass:[BKShopDetailViewController class]]) {
//                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
//                }
//                                                                                        
//            });            
//        }
//        else {
//            NSLog(@"Warning: order failed, error: %@", error);
//            self.HUD.mode = MBProgressHUDModeText;
//            if ([error.domain isEqualToString:BKErrorDomainWrongOrder]) {                
//                self.HUD.labelText = @"訂單錯誤";
//            }
//            else {
//                self.HUD.labelText = @"網路無回應";
//            }
//            [self.HUD hide:YES afterDelay:1.0];
//        }
//    }];   
}
@end
