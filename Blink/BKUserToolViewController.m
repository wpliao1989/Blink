//
//  userToolViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKUserToolViewController.h"
#import "BKAccountManager.h"
#import "BKShopInfoForUser.h"
#import "BKShopInfoManager.h"
#import "BKShopDetailViewController.h"
#import "BKOrderManager.h"
#import "UIViewController+BKBaseViewController.h"
#import "AKSegmentedControl.h"
#import "AKSegmentedControl+SelectedIndex.h"
#import "UIButton+AKSegmentedButton.h"
#import "UIButton+ChangeTitle.h"
#import "BKOrderContentForReceiving.h"
#import "BKOrderForReceiving.h"
#import "UIViewController+Formatter.h"
#import "BKUserOrderListCell.h"
#import "BKOrderConfirmViewController.h"
#import "NSString+Numeric.h"
#import "UIViewController+UserOrderListCell.h"
#import "UIViewController+ShopListCell.h"
#import "NSString+Additions.h"
#import "UIViewController+SharedString.h"
#import "UIViewController+SharedCustomizedUI.h"

@interface BKUserToolViewController ()

enum BKUserToolSegmentationSelection {
  BKUserToolSegmentationSelectionShop = 0,
  BKUserToolSegmentationSelectionOrder = 1,
  BKUserToolSegmentationSelectionUserData = 2
};

- (void)segmentationChanged:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)completeUnfinishedOrderButtonPressed:(id)sender;
- (IBAction)passwordModifyButtonPressed:(id)sender;
- (IBAction)confirmEditUserInfoButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *favoriteShopView;
@property (weak, nonatomic) IBOutlet UITableView *favoriteShopTableView;
@property (weak, nonatomic) IBOutlet UILabel *noFavoriteShopLabel;
@property (weak, nonatomic) IBOutlet UIView *orderListView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingOrdersIndicatorView;
@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (strong, nonatomic) NSArray *userFavoriteShops;
@property (strong, nonatomic) NSArray *orderlist;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentaionControl;
@property (weak, nonatomic) IBOutlet UIView *userDataModificationView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTokenLabel;
@property (strong, nonatomic) UIActionSheet *logoutActionSheet;
@property (weak, nonatomic) IBOutlet UIView *segmentedControlView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *userAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;

@property (strong, nonatomic) AKSegmentedControl *segmentedControl;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userToken;

- (void)initSegmentedControl;

@end

@implementation BKUserToolViewController

@synthesize userFavoriteShops = _userFavoriteShops;
@synthesize orderlist = _orderlist;
@synthesize userName = _userName;
@synthesize userPhone = _userPhone;
@synthesize userEmail = _userEmail;
@synthesize userAddress = _userAddress;
@synthesize userToken = _userToken;
@synthesize logoutActionSheet = _logoutActionSheet;

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameTextField.text = userName;
    //self.userNameLabel.text = userName;
}

- (void)setUserEmail:(NSString *)userEmail {
    _userEmail = userEmail;
    //self.userEmailLabel.text = userEmail;
    self.userEmailTextField.text = userEmail;
}

- (void)setUserPhone:(NSString *)userPhone {
    _userPhone = userPhone;
    self.userPhoneTextField.text = userPhone;
}

- (void)setUserAddress:(NSString *)userAddress {
    _userAddress = userAddress;
    self.userAddressTextField.text = userAddress;
}

- (void)setUserToken:(NSString *)userToken {
    _userToken = userToken;
    self.userTokenLabel.text = userToken;
}

- (NSArray *)userFavoriteShops {
    return [BKAccountManager sharedBKAccountManager].userFavoriteShops;
}

- (NSArray *)orderlist {
    return [BKAccountManager sharedBKAccountManager].userOrderlist;
}

- (UIActionSheet *)logoutActionSheet {
    if (_logoutActionSheet == nil) {
        _logoutActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Logging out?", @"確定登出?")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                           destructiveButtonTitle:NSLocalizedString(@"Logout", @"登出")
                                                otherButtonTitles:nil];
        [_logoutActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return _logoutActionSheet;
}

#pragma mark - View controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"self.shopIDs = %@", self.userFavoriteShops);
    [self initUserInfo];
    
    [self initSegmentedControl];
    [self.view setBackgroundColor:[self viewBackgoundColor]];
    
    [self.favoriteShopTableView registerNib:[UINib nibWithNibName:@"BKShopListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.orderListTableView registerNib:[UINib nibWithNibName:@"BKUserOrderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"orderListCell"];
    
    // Set the selected view to show, and make others to hide
    [self segmentationChanged:self.segmentedControl];
}

- (void)initUserInfo {
    self.userName = [BKAccountManager sharedBKAccountManager].userName;
    self.userPhone = [BKAccountManager sharedBKAccountManager].userPhone;
    self.userEmail = [BKAccountManager sharedBKAccountManager].userEmail;
    self.userToken = [BKAccountManager sharedBKAccountManager].userToken;
    self.userAddress = [BKAccountManager sharedBKAccountManager].userAddress;
}

- (void)initSegmentedControl {
    self.segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [self.segmentedControl addTarget:self action:@selector(segmentationChanged:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.segmentedControl setSelectedIndex:0];
    
    [self.segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
    
    UIColor *normalTextColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    UIColor *hilightedColor = [UIColor whiteColor];
    UIImage *pressedImage = [UIImage imageNamed:@"orange"];
    // Button 1    
    [self.firstButton changeButtonImage:nil pressedImage:pressedImage];
    [self.firstButton changeTextColor:normalTextColor highlightedColor:hilightedColor];
    
    // Button 2
    [self.secondButton changeButtonImage:nil pressedImage:pressedImage];
    [self.secondButton changeTextColor:normalTextColor highlightedColor:hilightedColor];
    
    // Button 3
    [self.thirdButton changeButtonImage:nil pressedImage:pressedImage];
    [self.thirdButton changeTextColor:normalTextColor highlightedColor:hilightedColor];
    
    [self.segmentedControl setButtonsArray:@[self.firstButton, self.secondButton, self.thirdButton]];
    [self.segmentedControlView addSubview:self.segmentedControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = self.scrollView.frame.size;
}

- (void)configureFavoriteShops {
    if (self.userFavoriteShops == nil) {
        [[BKAccountManager sharedBKAccountManager] getUserFavoriteShopsCompleteHandler:^(BOOL success) {
            //NSLog(@"!!!!!!!!!  %@", self.userFavoriteShops);
            [self.favoriteShopTableView reloadData];
            self.noFavoriteShopLabel.hidden = self.userFavoriteShops.count > 0;
        }];
    }
    else {
        [self.favoriteShopTableView reloadData];
        self.noFavoriteShopLabel.hidden = self.userFavoriteShops.count > 0;
    }
}

- (void)configureOrderList {
//    if (self.orderlist == nil) {
//        [[BKAccountManager sharedBKAccountManager] getUserOrdersCompleteHandler:^(BOOL success) {
//            NSLog(success ? @"Get order success!" : @"Get order failed!");
//            //NSLog(@"self.orderlist = %@", self.orderlist);
//            [self.orderListTableView reloadData];
//        }];
//    }
    [self.loadingOrdersIndicatorView startAnimating];
    [[BKAccountManager sharedBKAccountManager] getUserOrdersCompleteHandler:^(BOOL success) {
        NSLog(success ? @"Get order success!" : @"Get order failed!");
        //NSLog(@"self.orderlist = %@", self.orderlist);
        [self.orderListTableView reloadData];
        [self.loadingOrdersIndicatorView stopAnimating];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.favoriteShopTableView deselectRowAtIndexPath:[self.favoriteShopTableView indexPathForSelectedRow] animated:YES];
    [self.orderListTableView deselectRowAtIndexPath:[self.orderListTableView indexPathForSelectedRow] animated:YES];
    
    [self configureFavoriteShops];
    [self configureOrderList];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromFavoriteShopDetailSegue"]) {
        if ([sender isKindOfClass:[BKShopInfoForUser class]]) {
            BKShopInfoForUser *shopInfo = sender;
            BKShopDetailViewController *shopDetailViewController = segue.destinationViewController;
            NSString *shopID = shopInfo.sShopID;
            shopDetailViewController.shopID = shopID;
        }
    }
    else if ([segue.identifier isEqualToString:@"fromUnfinishedOrderSegue"]) {
        BKShopDetailViewController *detailVC = segue.destinationViewController;       
        detailVC.shopID = [[BKOrderManager sharedBKOrderManager] shopID];
    }
    else if ([segue.identifier isEqualToString:@"userToolToOrderConfirmSegue"]) {
        BKOrderConfirmViewController *orderConfirmVC = segue.destinationViewController;
        orderConfirmVC.order = sender;
        NSLog(@"order:%@", [orderConfirmVC.order class]);
    }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger dataCount;
    
    if(tableView == self.favoriteShopTableView) {
        dataCount = self.userFavoriteShops.count;
    }
    else if (tableView == self.orderListTableView) {
        dataCount = self.orderlist.count;
    }
    else {
        dataCount = 0;
    }
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.favoriteShopTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        BKShopInfoForUser *theShopInfo = [self.userFavoriteShops objectAtIndex:indexPath.row];
        [self configureShopListCell:cell withShopInfo:theShopInfo];
        return cell;
    }
    else if (tableView == self.orderListTableView) {
        BKUserOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell"];        
        BKOrderForReceiving *theOrder = [self.orderlist objectAtIndex:indexPath.row];        
        [self configureUserOrderListCell:cell withOrder:theOrder];
        
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (![cell.reuseIdentifier isEqualToString:@"cell"]) {
//        return;
//    }
//    BKShopInfoForUser *theShopInfo = [self.userFavoriteShops objectAtIndex:indexPath.row];
//    
//    if (cell.imageView.image == nil || cell.imageView.image == [self defaultPicture]) {
//        
//        [self downloadImageForShopInfo:theShopInfo completeHandler:^(UIImage *image) {
//            UITableViewCell *theCell = [self.favoriteShopTableView cellForRowAtIndexPath:indexPath];
//            [self setImageView:theCell.imageView withImage:image];
//        }];
//    }    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.favoriteShopTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.reuseIdentifier isEqualToString:@"cell"]) {
            BKShopInfoForUser *theShopInfo = [self.userFavoriteShops objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"fromFavoriteShopDetailSegue" sender:theShopInfo];
        }    
    }
    else if (tableView == self.orderListTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.reuseIdentifier isEqualToString:@"orderListCell"]) {
            id order = [self.orderlist objectAtIndex:indexPath.row];
            if ([order isKindOfClass:[BKOrderForReceiving class]]) {
                [self performSegueWithIdentifier:@"userToolToOrderConfirmSegue" sender:order];
            }        
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.favoriteShopTableView) {
        return YES;
    }
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.favoriteShopTableView) {
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            //
//        }
//    }    
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.favoriteShopTableView) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    static NSInteger logout = 0;
    if (buttonIndex == logout) {
        [[BKAccountManager sharedBKAccountManager] logout];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Text field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    if (textField == self.userPhoneTextField) {
        NSLog(@"text change in range: %@, with string: %@", NSStringFromRange(range), string);
        NSLog(@"current string length: %d", textField.text.length);
        
        if ([string isAllDigits]) {
            return YES;
        }
        else if ([string isEqualToString:@" "] && range.length > 0) {
            // The character is space, but the action is deleting, thus return YES
            return YES;
        }
        else {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    if (textField == self.userNameTextField) {
        self.userName = [textField.text cleanString];
    }
    else if (textField == self.userPhoneTextField) {
        self.userPhone = [textField.text cleanString];
    }
    else if (textField == self.userAddressTextField) {
        self.userAddress = [textField.text cleanString];
    }
    else if (textField == self.userEmailTextField) {
        self.userEmail = [textField.text cleanString];
    }
    
    NSLog(@"name:%@, phone:%@, address:%@, email:%@", self.userName, self.userPhone, self.userAddress, self.userEmail);
}

#pragma mark - IBActions

- (void)segmentationChanged:(AKSegmentedControl *)sender {
    NSLog(@"segment changed!");
    if (sender.firstSelectedIndex == BKUserToolSegmentationSelectionShop){
        [self.favoriteShopTableView reloadData];
        self.favoriteShopView.hidden = NO;
        self.orderListView.hidden = YES;
        self.userDataModificationView.hidden = YES;
    }
    else if (sender.firstSelectedIndex == BKUserToolSegmentationSelectionOrder) {
        [self.orderListTableView reloadData];
        self.favoriteShopView.hidden = YES;
        self.orderListView.hidden = NO;
        self.userDataModificationView.hidden = YES;        
    }    
    else if (sender.firstSelectedIndex == BKUserToolSegmentationSelectionUserData) {
        self.favoriteShopView.hidden = YES;
        self.orderListView.hidden = YES;
        self.userDataModificationView.hidden = NO;        
    }
}

- (IBAction)logoutButtonPressed:(id)sender {    
    [self.logoutActionSheet showInView:self.view];
}

- (IBAction)completeUnfinishedOrderButtonPressed:(id)sender {
    if ([[BKOrderManager sharedBKOrderManager] hasOrder]) {
        [self performSegueWithIdentifier:@"fromUnfinishedOrderSegue" sender:self];
    }
}

- (IBAction)passwordModifyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"passwordModifySegue" sender:self];
}

- (IBAction)confirmEditUserInfoButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    if ([self.userName hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your name", @"請輸入姓名")];
        return;
    }
    
    if ([self.userPhone hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your phone numeber", @"請輸入電話")];
        return;
    }
    
    if ([self.userAddress hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your address", @"請輸入地址")];
        return;
    }
    
    if ([self.userEmail hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your email", @"")];
        return;
    }
    else if (![self.userEmail isEmailFormat]) {
        [self showAlert:NSLocalizedString(@"Email format is incorrect", @"")];
        return;
    } 
    
    [self showHUDViewWithMessage:NSLocalizedString(@"Modidying...", @"")];
}

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    [[BKAccountManager sharedBKAccountManager] editUserName:self.userName address:self.userAddress email:self.userEmail phone:self.userPhone completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            successBlock(NSLocalizedString(@"Modification succeeded!", @""));
        }
        else {
            failBlock(error);
        }
    }];
}

- (void)viewDidUnload {
    [self setFirstButton:nil];
    [self setUserNameTextField:nil];
    [self setUserPhoneTextField:nil];
    [self setUserAddressTextField:nil];
    [super viewDidUnload];
}
@end
