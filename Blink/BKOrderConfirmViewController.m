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
#import "BKShopInfoManager.h"
#import "BKAccountManager.h"
#import "UIViewController+BKBaseViewController.h"
#import "BKMenuItemForReceiving.h"
#import "UIViewController+Formatter.h"
#import "BKOrderForSending.h"
#import "BKOrderForReceiving.h"
#import "BKOrderContent.h"
#import "UIViewController+SharedCustomizedUI.h"
#import "BKNoteViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "BKModifyUserInfoViewController.h"

@interface BKOrderConfirmViewController ()<BKNoteViewDelegate, BKModifyUserInfoViewControllerDelegate>

- (IBAction)orderConfirmButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgrond;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyUserInfoButton;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;

- (NSString *)stringForSize:(NSString *)size quantity:(NSNumber *)quantity ice:(NSString *)ice sweetness:(NSString *)sweetness;
- (NSString *)stringFromDate:(NSDate *)date;

@property (nonatomic) BOOL orderIsForReview;

- (void)initUserInfos;
- (void)setUpLabels;

- (IBAction)noteButtonPressed:(id)sender;
- (IBAction)modifyUserInfoButtonPressed:(id)sender;

@end

@implementation BKOrderConfirmViewController

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

- (BOOL)orderIsForReview {
    return [self.order isKindOfClass:[BKOrderForReceiving class]];
}

- (void)initUserInfos {
    self.userName = self.order.name;
    self.userPhone = self.order.phone;
    self.userAddress = self.order.address;
}

- (void)setUpLabels {
    NSLog(@"date: %@", [BKOrderManager sharedBKOrderManager].recordTime);
    
//    self.timeLabel.text = [self stringFromDate:[BKOrderManager sharedBKOrderManager].recordTime];
//    self.totalPriceLabel.text = [self stringForTotalPrice:[[BKOrderManager sharedBKOrderManager] totalPriceForShop:self.shopInfo]];
//    self.shopNameLabel.text = [[BKOrderManager sharedBKOrderManager] shopName];
    self.timeLabel.text = [self stringFromDate:self.order.recordTime];
    self.totalPriceLabel.text = [self stringForTotalPrice:self.order.totalPrice];
    self.shopNameLabel.text = self.order.shopName;
}

- (void)setUpButtons {
    if (self.orderIsForReview) {
        self.orderConfirmButton.hidden = YES;
        self.modifyUserInfoButton.hidden = YES;
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"self.order = %@", self.order);
    
    [self initUserInfos];
    [self setUpLabels];
    [self setUpButtons];
    [self.view setBackgroundColor:[self viewBackgoundColor]];
    [self.backgrond setImage:[self resizableListImage]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Order confirm view will appear!");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Order confirm view did appear!");
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
    if ([BKMenuItemForReceiving localizedStringForIce:ice] != nil) {
        [strings addObject:[BKMenuItemForReceiving localizedStringForIce:ice]];
    }
    if ([BKMenuItemForReceiving localizedStringForSweetness:sweetness] != nil) {
        [strings addObject:[BKMenuItemForReceiving localizedStringForSweetness:sweetness]];
    }
    
    NSString *iceAndSweetness = strings.count > 0 ? [NSString stringWithFormat:@"(%@)", [strings componentsJoinedByString:@"、"]] : @"";
    
    return [NSString stringWithFormat:@"%@ %@ %@", [quantity stringValue], [BKMenuItemForReceiving localizedStringForSize:size], iceAndSweetness];
}

#pragma mark - Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.order numberOfOrderContents];
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
    
    BKOrderContent *orderContent = [self.order orderContentAtIndex:indexPath.row];
    name.text = orderContent.name;
    basePrice.text = [orderContent.basePrice stringValue];
    quantity.text = [orderContent.quantity stringValue];
    price.text = [self currencyStringForPrice:orderContent.priceValue];
    sizeQuantityIceSweet.text = [self stringForSize:orderContent.size quantity:orderContent.quantity ice:orderContent.ice sweetness:orderContent.sweetness];
//    sweetness.text = orderContent.sweetness;
//    ice.text = orderContent.ice;
    
    return cell;
}

#pragma mark - BKNoteViewDelegate

- (void)confirmButtonPressed:(BKNoteViewController *)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

#pragma mark - BKModifyUserInfoViewControllerDelegate

- (void)modifyUserInfoVC:(BKModifyUserInfoViewController *)sender didFinishedModificationSavingInfo:(BOOL)savesInfo {
    NSLog(@"did finished modification, name:%@, phone:%@, address:%@, saves info:%@", sender.userName, sender.userPhone, sender.userAddress, savesInfo ? @"YES" : @"NO");
    self.userName = sender.userName;
    self.userPhone = sender.userPhone;
    self.userAddress = sender.userAddress;
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
    [[BKAccountManager sharedBKAccountManager] editUserName:sender.userName address:sender.userAddress email:[BKAccountManager sharedBKAccountManager].userEmail phone:sender.userPhone completionHandler:^(BOOL success, NSError *error) {}];
}

#pragma mark - Send order

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    [[BKOrderManager sharedBKOrderManager] sendOrderWithCompleteHandler:^(BOOL success, NSError *error) {
        if (success) {
            [[BKOrderManager sharedBKOrderManager] clear];
            successBlock(NSLocalizedString(@"Order succeeded!", @"訂購成功！"));
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
    [[BKOrderManager sharedBKOrderManager] setUserToken:((BKOrderForSending *)self.order).userToken userName:self.userName userPhone:self.userPhone userAddress:self.userAddress];
    [self showHUDViewWithMessage:NSLocalizedString(@"Sending order...", @"訂購中...")];
}

- (IBAction)noteButtonPressed:(id)sender {
    BKNoteViewController *note = [self.storyboard instantiateViewControllerWithIdentifier:@"BKNoteVC"];
    note.delegate = self;
    note.note = self.order.note;
    note.noteIsEditable = NO;
    
    [self presentPopupViewController:note animationType:MJPopupViewAnimationSlideBottomBottom];
}

- (IBAction)modifyUserInfoButtonPressed:(id)sender {
    BKModifyUserInfoViewController *modifyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BKModifyUserInfoViewController"];
    [modifyVC view]; // Force viewDidLoad to fire
    modifyVC.userName = self.userName;
    modifyVC.userPhone = self.userPhone;
    modifyVC.userAddress = self.userAddress;
    modifyVC.delegate = self;
    
    [self presentPopupViewController:modifyVC animationType:MJPopupViewAnimationSlideRightRight];
}

@end
