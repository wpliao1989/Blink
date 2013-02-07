//
//  userToolViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKUserToolViewController.h"
#import "BKAccountManager.h"

@interface BKUserToolViewController ()

enum BKUserToolSegmentationSelection {
  BKUserToolSegmentationSelectionShop = 0,
  BKUserToolSegmentationSelectionOrder = 1,
  BKUserToolSegmentationSelectionUserData = 2
};

- (IBAction)segmentationChanged:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *userToolTableView;
@property (strong, nonatomic) NSMutableArray *shopList;
@property (strong, nonatomic) NSMutableArray *orderlist;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentaionControl;
@property (strong, nonatomic) IBOutlet UIView *userDataModificationView;

@end

@implementation BKUserToolViewController

@synthesize userToolTableView = _userToolTableView;
@synthesize segmentaionControl = _segmentaionControl;
@synthesize shopList = _shopList;
@synthesize orderlist = _orderlist;

- (NSMutableArray *)shopList {
    if (_shopList == nil) {
        _shopList = [NSMutableArray arrayWithObjects:@"50藍", @"成時", @"王品", nil];
    }
    return  _shopList;
}

- (NSMutableArray *)orderlist {
    if (_orderlist == nil) {
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
}

- (void)viewWillAppear:(BOOL)animated {
    [self.userToolTableView deselectRowAtIndexPath:[self.userToolTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger dataCount;
    
    if(self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionShop) {
        dataCount = self.shopList.count;
    }
    else if (self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionOrder) {
        dataCount = self.orderlist.count;
    }
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(self.segmentaionControl.selectedSegmentIndex == BKUserToolSegmentationSelectionShop) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell"];
        cell.textLabel.text = [self.shopList objectAtIndex:indexPath.row];
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
