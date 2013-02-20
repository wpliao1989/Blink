//
//  shopListViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopListViewController.h"
#import "BKAPIManager.h"
//#import "BKMainPageViewController.h"

@interface BKShopListViewController ()

typedef enum  {
    BKListActionSheetButtonIndexDistant = 0,
    BKListActionSheetButtonIndexPrice = 1,
    BKListActionSheetButtonIndexScore = 2
}BKListActionSheetButtonIndex;

//typedef enum  {
//    BKSortActionSheetButtonIndex = 0,
//    BKSortActionSheetButtonIndex = 1,
//    BKSortActionSheetButtonIndex = 2
//}BKSortActionSheetButtonIndex;

//- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)mapButtonPressed:(id)sender;
- (IBAction)listButtonPressed:(id)sender;
- (IBAction)sortButtonPressed:(id)sender;
- (IBAction)categoryButtonPressed:(id)sender;
- (IBAction)locateUserButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *mainContentView;
@property (strong, nonatomic) IBOutlet MKMapView *shopListMapView;
@property (strong, nonatomic) IBOutlet UITableView *shopListTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sortButton;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *locateUserButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIActionSheet *listActionSheet;
@property (strong, nonatomic) UIActionSheet *sortActionSheet;

@end

@implementation BKShopListViewController

@synthesize mainContentView = _mainContentView;
@synthesize mapButton = _mapButton;
@synthesize listButton = _listButton;
@synthesize sortButton = _sortButton;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize shopListMapView = _shopListMapView;
@synthesize shopListTableView = _shopListTableView;
@synthesize listActionSheet = _listActionSheet;
@synthesize sortActionSheet = _sortActionSheet;
@synthesize searchBar = _searchBar;

- (UIActionSheet *)listActionSheet {
    if (_listActionSheet == nil) {
        _listActionSheet = [[UIActionSheet alloc] initWithTitle:@"排序" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"依距離", @"依價格", @"依評價", nil];
        [_listActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return _listActionSheet;
}

- (UIActionSheet *)sortActionSheet {
    _sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"分類" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"飲料", @"中式", @"西式", nil];
    [_sortActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    return _sortActionSheet;
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
//    [self.mainContentView addSubview:[[BKShopListTableViewController alloc] initWithNibName:@"BKShopListTableViewController" bundle:[NSBundle mainBundle]].view];
//    NSLog(@"selected cell: %@", [self.shopListTableView indexPathForSelectedRow]);
//    self.navigationItem.rightBarButtonItem = ((BKMainPageViewController *)[self.navigationController.viewControllers objectAtIndex:0]).homeButton;
    [[BKAPIManager sharedBKAPIManager] listWithListCriteria:BKListCriteriaDistant];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.shopListTableView deselectRowAtIndexPath:[self.shopListTableView indexPathForSelectedRow] animated:YES];    
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource, TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"shopDetailSegue" sender:self];
}

#pragma mark - Mapview delegate

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    self.locateUserButton.enabled = !(mode == MKUserTrackingModeFollow);
}

#pragma mark - Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"action sheet = %@", actionSheet);
//    NSLog(@"buttonIndex = %d", buttonIndex);
    if (actionSheet == self.listActionSheet) {
        switch (buttonIndex) {
            case BKListActionSheetButtonIndexDistant:
                [[BKAPIManager sharedBKAPIManager] listWithListCriteria:BKListCriteriaDistant];
                break;
            case BKListActionSheetButtonIndexPrice:
                [[BKAPIManager sharedBKAPIManager] listWithListCriteria:BKListCriteriaPrice];
                break;
            case BKListActionSheetButtonIndexScore:
                [[BKAPIManager sharedBKAPIManager] listWithListCriteria:BKListCriteriaScore];
                break;
            default:                
                break;
        }
    }
    else if (actionSheet == self.sortActionSheet) {
//        switch (buttonIndex) {
//            case 0:
//                
//                break;
//                
//            default:
//                break;
//        }
    }
}

#pragma mark - IBActions

//- (IBAction)homeButtonPressed:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (IBAction)mapButtonPressed:(id)sender {
//    [UIView transitionFromView:self.mainContentView toView:self.testView duration:1.0 options: UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
//        
//    }];
//    self.shopListMapView.frame = self.mainContentView.frame;
    self.mapButton.enabled = NO;
    self.sortButton.enabled = NO;
    
    
    [UIView transitionWithView:self.mainContentView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.shopListMapView.hidden = NO;
        self.shopListTableView.hidden = YES;
        
    } completion:^(BOOL finished) {
        
        NSMutableArray *bottomToolBarItems = [self.bottomToolBar.items mutableCopy];
        [bottomToolBarItems replaceObjectAtIndex:0 withObject:self.listButton];
        self.bottomToolBar.items = [NSArray arrayWithArray:bottomToolBarItems];
        self.mapButton.enabled = YES;
        self.navigationItem.rightBarButtonItem = self.locateUserButton;
    }];
}

- (IBAction)listButtonPressed:(id)sender {
//    [UIView transitionFromView:self.testView toView:self.mainContentView duration:1.0 options: UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//        
//    }];
    self.listButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = nil;
    
    [UIView transitionWithView:self.mainContentView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.shopListMapView.hidden = YES;
        self.shopListTableView.hidden = NO;
        
        
    } completion:^(BOOL finished) {
        
        NSMutableArray *bottomToolBarItems = [self.bottomToolBar.items mutableCopy];
        [bottomToolBarItems replaceObjectAtIndex:0 withObject:self.mapButton];
        self.bottomToolBar.items = [NSArray arrayWithArray:bottomToolBarItems];
        self.listButton.enabled = YES;
        self.sortButton.enabled = YES;        
    }];    
}

- (IBAction)sortButtonPressed:(id)sender {    
    [self.listActionSheet showInView:self.mainContentView];
}

- (IBAction)categoryButtonPressed:(id)sender {    
    [self.sortActionSheet showInView:self.mainContentView];
}

- (IBAction)locateUserButtonPressed:(id)sender {
    [self.shopListMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (IBAction)searchButtonPressed:(id)sender {
    if ([self.searchBar.text length] > 0) {
        [[BKAPIManager sharedBKAPIManager] searchWithShopName:self.searchBar.text];
    }
}
@end
