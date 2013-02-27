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

@interface BKUserToolViewController ()

enum BKUserToolSegmentationSelection {
  BKUserToolSegmentationSelectionShop = 0,
  BKUserToolSegmentationSelectionOrder = 1,
  BKUserToolSegmentationSelectionUserData = 2
};

- (IBAction)segmentationChanged:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *userToolTableView;
@property (strong, nonatomic) NSArray *shopIDList;
@property (strong, nonatomic) NSArray *orderlist;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentaionControl;
@property (strong, nonatomic) IBOutlet UIView *userDataModificationView;

@end

@implementation BKUserToolViewController

@synthesize userToolTableView = _userToolTableView;
@synthesize segmentaionControl = _segmentaionControl;
@synthesize shopIDList = _shopIDList;
@synthesize orderlist = _orderlist;

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
        _orderlist = [NSMutableArray arrayWithObjects:@"雞排", @"紅茶", @"小雞腿", nil];
    }
    return _orderlist;
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
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger dataCount;
    
    if(self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionShop) {
        dataCount = self.shopIDList.count;
    }
    else if (self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionOrder) {
        dataCount = self.orderlist.count;
    }
    else {
        dataCount = 0;
    }
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionShop) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];        
        cell.textLabel.text = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:[self.shopIDList objectAtIndex:indexPath.row]].name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Shop #%d", indexPath.row];
    }
    else if (self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionOrder) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        cell.textLabel.text = [self.orderlist objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Order #%d", indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionShop) {
        [self performSegueWithIdentifier:@"fromFavoriteShopDetailSegue" sender:self];
    }
    else if (self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionOrder) {
        
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

- (IBAction)segmentationChanged:(UISegmentedControl *)sender {
    if ((sender.selectedSegmentIndex == BKUserToolSegmentationSelectionShop) || (sender.selectedSegmentIndex == BKUserToolSegmentationSelectionOrder) ){
        self.userToolTableView.hidden = NO;
        self.userDataModificationView.hidden = YES;
        [self.userToolTableView reloadData];
    }
    else if (sender.selectedSegmentIndex == BKUserToolSegmentationSelectionUserData) {
        self.userToolTableView.hidden = YES;
        self.userDataModificationView.hidden = NO;
    }
}

- (IBAction)logoutButtonPressed:(id)sender {
    UIActionSheet *logoutActionSheet = [[UIActionSheet alloc] initWithTitle:@"確定登出?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"登出" otherButtonTitles:nil];
    [logoutActionSheet showInView:self.view];
    
    
}
@end
