//
//  userToolViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKUserToolViewController.h"
#import "BKAccountManager.h"
#import "BKShopInfo.h"
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

@interface BKUserToolViewController ()

enum BKUserToolSegmentationSelection {
  BKUserToolSegmentationSelectionShop = 0,
  BKUserToolSegmentationSelectionOrder = 1,
  BKUserToolSegmentationSelectionUserData = 2
};

- (void)segmentationChanged:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)completeUnfinishedOrderButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *favoriteShopTableView;
@property (strong, nonatomic) IBOutlet UITableView *orderListTableView;
@property (strong, nonatomic) NSArray *userFavoriteShops;
@property (strong, nonatomic) NSArray *orderlist;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentaionControl;
@property (strong, nonatomic) IBOutlet UIView *userDataModificationView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTokenLabel;
@property (strong, nonatomic) UIActionSheet *logoutActionSheet;
@property (weak, nonatomic) IBOutlet UIView *segmentedControlView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@property (strong, nonatomic) AKSegmentedControl *segmentedControl;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userToken;

- (void)initSegmentedControl;

@end

@implementation BKUserToolViewController

@synthesize userFavoriteShops = _userFavoriteShops;
@synthesize orderlist = _orderlist;
@synthesize userName = _userName;
@synthesize userEmail = _userEmail;
@synthesize userToken = _userToken;
@synthesize logoutActionSheet = _logoutActionSheet;

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameLabel.text = userName;
}

- (void)setUserEmail:(NSString *)userEmail {
    _userEmail = userEmail;
    self.userEmailLabel.text = userEmail;
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
        _logoutActionSheet = [[UIActionSheet alloc] initWithTitle:@"確定登出?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登出" otherButtonTitles:nil];
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
    self.userName = [BKAccountManager sharedBKAccountManager].userName;
    self.userEmail = [BKAccountManager sharedBKAccountManager].userEmail;
    self.userToken = [BKAccountManager sharedBKAccountManager].userToken;
    
    [self initSegmentedControl];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
    
    [self.favoriteShopTableView registerNib:[UINib nibWithNibName:@"BKShopListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.orderListTableView registerNib:[UINib nibWithNibName:@"BKUserOrderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"orderListCell"];
    
    if (self.userFavoriteShops == nil) {
        [[BKAccountManager sharedBKAccountManager] getUserFavoriteShopsCompleteHandler:^(BOOL success) {
            //NSLog(@"!!!!!!!!!  %@", self.userFavoriteShops);
            [self.favoriteShopTableView reloadData];
        }];
    }
    
    [[BKAccountManager sharedBKAccountManager] getUserOrdersCompleteHandler:^(BOOL success) {
        NSLog(success ? @"Get order success!" : @"Get order failed!");
        //NSLog(@"self.orderlist = %@", self.orderlist);
        [self.orderListTableView reloadData];
    }];
    
    // Set the selected view to show, and make others to hide
    [self segmentationChanged:self.segmentedControl];
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

- (void)viewWillAppear:(BOOL)animated {
    [self.favoriteShopTableView deselectRowAtIndexPath:[self.favoriteShopTableView indexPathForSelectedRow] animated:YES];
    [self.orderListTableView deselectRowAtIndexPath:[self.orderListTableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromFavoriteShopDetailSegue"]) {
        BKShopDetailViewController *detailVC = segue.destinationViewController;
//        detailVC.shopInfo = [self.shopList objectAtIndex:[self.userToolTableView indexPathForSelectedRow].row];
        NSInteger selectedIndex = [self.favoriteShopTableView indexPathForSelectedRow].row;
        detailVC.shopID = [self.userFavoriteShops objectAtIndex:selectedIndex];
    }
    else if ([segue.identifier isEqualToString:@"fromUnfinishedOrderSegue"]) {
        BKShopDetailViewController *detailVC = segue.destinationViewController;       
        detailVC.shopID = [[BKOrderManager sharedBKOrderManager] shopID];
    }
    else if ([segue.identifier isEqualToString:@"userToolToOrderConfirmSegue"]) {
        BKOrderConfirmViewController *orderConfirmVC = segue.destinationViewController;
        orderConfirmVC.order = sender;
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
        cell.textLabel.text = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:[self.userFavoriteShops objectAtIndex:indexPath.row]].name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Shop #%d", indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.favoriteShopTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.reuseIdentifier isEqualToString:@"shopCell"]) {
            [self performSegueWithIdentifier:@"fromFavoriteShopDetailSegue" sender:[self.orderlist objectAtIndex:indexPath.row]];
        }    
    }
    else if (tableView == self.orderListTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.reuseIdentifier isEqualToString:@"orderListCell"]) {
            [self performSegueWithIdentifier:@"userToolToOrderConfirmSegue" sender:self];
        }
    }
}

#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    static NSInteger logout = 0;
    if (buttonIndex == logout) {
        [[BKAccountManager sharedBKAccountManager] logout];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - IBActions

- (void)segmentationChanged:(AKSegmentedControl *)sender {
    NSLog(@"segment changed!");
    if (sender.firstSelectedIndex == BKUserToolSegmentationSelectionShop){
        [self.favoriteShopTableView reloadData];
        self.favoriteShopTableView.hidden = NO;
        self.orderListTableView.hidden = YES; 
        self.userDataModificationView.hidden = YES;
    }
    else if (sender.firstSelectedIndex == BKUserToolSegmentationSelectionOrder) {
        [self.orderListTableView reloadData];
        self.favoriteShopTableView.hidden = YES;
        self.orderListTableView.hidden = NO;
        self.userDataModificationView.hidden = YES;        
    }    
    else if (sender.firstSelectedIndex == BKUserToolSegmentationSelectionUserData) {
        self.favoriteShopTableView.hidden = YES;
        self.orderListTableView.hidden = YES;
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
- (void)viewDidUnload {
    [self setFirstButton:nil];
    [super viewDidUnload];
}
@end
