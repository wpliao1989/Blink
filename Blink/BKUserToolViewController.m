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

@interface BKUserToolViewController ()

enum BKUserToolSegmentationSelection {
  BKUserToolSegmentationSelectionShop = 0,
  BKUserToolSegmentationSelectionOrder = 1,
  BKUserToolSegmentationSelectionUserData = 2
};

- (void)segmentationChanged:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)completeUnfinishedOrderButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *userToolTableView;
@property (strong, nonatomic) NSArray *shopIDList;
@property (strong, nonatomic) NSArray *orderlist;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentaionControl;
@property (strong, nonatomic) IBOutlet UIView *userDataModificationView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTokenLabel;
@property (strong, nonatomic) UIActionSheet *logoutActionSheet;
@property (strong, nonatomic) AKSegmentedControl *segmentedControl;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userToken;

- (void)initSegmentedControl;

@end

@implementation BKUserToolViewController

@synthesize userToolTableView = _userToolTableView;
//@synthesize segmentaionControl = _segmentaionControl;
@synthesize shopIDList = _shopIDList;
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

- (NSArray *)shopIDList {
    if (_shopIDList == nil) {
#warning Test shop list
//        _shopList = [NSMutableArray arrayWithObjects:@"50藍", @"成時", @"王品", nil];
        _shopIDList = [BKAccountManager sharedBKAccountManager].favoriteShopIDs;
    }
    return  _shopIDList;
}

- (NSArray *)orderlist {
    if (_orderlist == nil) {
#warning Test order list
//        _orderlist = [NSMutableArray arrayWithObjects:@"雞排", @"紅茶", @"小雞腿", nil];
        _orderlist = [NSMutableArray array];
    }
    return _orderlist;
}

- (UIActionSheet *)logoutActionSheet {
    if (_logoutActionSheet == nil) {
        _logoutActionSheet = [[UIActionSheet alloc] initWithTitle:@"確定登出?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登出" otherButtonTitles:nil];
        [_logoutActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return _logoutActionSheet;
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
    NSLog(@"self.shopIDs = %@", self.shopIDList);
    self.userName = [BKAccountManager sharedBKAccountManager].userName;
    self.userEmail = [BKAccountManager sharedBKAccountManager].userEmail;
    self.userToken = [BKAccountManager sharedBKAccountManager].userToken;
    
    [self initSegmentedControl];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
//    CGRect frame = self.segmentaionControl.frame;
//    [self.segmentaionControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100)];
}

- (void)initSegmentedControl {
    self.segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 34.0)];
    [self.segmentedControl addTarget:self action:@selector(segmentationChanged:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.segmentedControl setSelectedIndex:0];
    
    [self.segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    // Button 1
    UIButton *leftButton = [[UIButton alloc] init];
    UIImage *leftButtonImage = [UIImage imageNamed:@"e1.png"];
    UIImage *leftButtonPressedImage = [UIImage imageNamed:@"e1_press"];    
    
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton setImage:leftButtonPressedImage forState:UIControlStateSelected];
    [leftButton setImage:leftButtonPressedImage forState:UIControlStateHighlighted];
    [leftButton setImage:leftButtonPressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *midButton = [[UIButton alloc] init];
    UIImage *midButtonImage = [UIImage imageNamed:@"e3.png"];
    UIImage *midButtonPressedImage = [UIImage imageNamed:@"e3_press"];    
    
    [midButton setImage:midButtonImage forState:UIControlStateNormal];
    [midButton setImage:midButtonPressedImage forState:UIControlStateSelected];
    [midButton setImage:midButtonPressedImage forState:UIControlStateHighlighted];
    [midButton setImage:midButtonPressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 3
    UIButton *rightButton = [[UIButton alloc] init];
    UIImage *rightButtonImage = [UIImage imageNamed:@"e2.png"];
    UIImage *rightButtonPressedImage = [UIImage imageNamed:@"e2_press"];
    
    [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    [rightButton setImage:rightButtonPressedImage forState:UIControlStateSelected];
    [rightButton setImage:rightButtonPressedImage forState:UIControlStateHighlighted];
    [rightButton setImage:rightButtonPressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [self.segmentedControl setButtonsArray:@[leftButton, midButton, rightButton]];
    [self.view addSubview:self.segmentedControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.userToolTableView deselectRowAtIndexPath:[self.userToolTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromFavoriteShopDetailSegue"]) {
        BKShopDetailViewController *detailVC = segue.destinationViewController;
//        detailVC.shopInfo = [self.shopList objectAtIndex:[self.userToolTableView indexPathForSelectedRow].row];
        NSInteger selectedIndex = [self.userToolTableView indexPathForSelectedRow].row;
        detailVC.shopID = [self.shopIDList objectAtIndex:selectedIndex];
        
    }
    else if ([segue.identifier isEqualToString:@"fromUnfinishedOrderSegue"]) {
        BKShopDetailViewController *detailVC = segue.destinationViewController;       
        detailVC.shopID = [[BKOrderManager sharedBKOrderManager] shopID];
    }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger dataCount;
    
    if(self.segmentedControl.firstSelectedIndex == BKUserToolSegmentationSelectionShop) {
        dataCount = self.shopIDList.count;
    }
    else if (self.segmentedControl.firstSelectedIndex == BKUserToolSegmentationSelectionOrder) {
        dataCount = self.orderlist.count;
    }
    else {
        dataCount = 0;
    }
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(self.segmentedControl.firstSelectedIndex == BKUserToolSegmentationSelectionShop) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];        
        cell.textLabel.text = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:[self.shopIDList objectAtIndex:indexPath.row]].name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Shop #%d", indexPath.row];
    }
    else if (self.segmentedControl.firstSelectedIndex == BKUserToolSegmentationSelectionOrder) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        cell.textLabel.text = [self.orderlist objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Order #%d", indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.segmentedControl.firstSelectedIndex == BKUserToolSegmentationSelectionShop) {
        [self performSegueWithIdentifier:@"fromFavoriteShopDetailSegue" sender:self];
    }
    else if (self.segmentedControl.firstSelectedIndex == BKUserToolSegmentationSelectionOrder) {
        
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
    if ((sender.firstSelectedIndex == BKUserToolSegmentationSelectionShop) || (sender.firstSelectedIndex == BKUserToolSegmentationSelectionOrder) ){
        self.userToolTableView.hidden = NO;
        self.userDataModificationView.hidden = YES;
        [self.userToolTableView reloadData];
    }
    else if (sender.firstSelectedIndex == BKUserToolSegmentationSelectionUserData) {
        self.userToolTableView.hidden = YES;
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
@end
