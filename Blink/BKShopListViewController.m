//
//  shopListViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopListViewController.h"
#import "BKAPIManager.h"
#import "BKShopInfoManager.h"
#import "BKShopDetailViewController.h"

#import "BKTestCenter.h"

//@interface UITableView (CustomAnimation)
//
//- (void)reloadData:(BOOL)animated;
//
//@end
//
//@implementation UITableView (CustomAnimation)
//
//- (void)reloadData:(BOOL)animated {
//    [self reloadData];
//    
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        [animation setType:kCATransitionFromTop];
////        [animation setSubtype:kCATransitionFromBottom];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [animation setFillMode:kCAFillModeBoth];
//        [animation setDuration:.3];
//        [self.layer addAnimation:animation forKey:@"UITableviewReloadDataAnimationKey"];        
//    }
//}
//
//@end

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
//@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (nonatomic) CLLocationCoordinate2D userCoordinate;
//@property (nonatomic) BOOL isLoadingNewData;
//@property (nonatomic) BOOL isLocationServiceEnabled;

//@property (strong, nonatomic) NSMutableArray *shopInfos;

- (void)saveShopInfosWithShopIDs:(NSArray *)shopIDs;
// Methods for reloading data based on list criteria
- (void)reloadDataAccordingToListCriteria:(BKListCriteria)criteria;
- (void)locationDidChange;
- (void)locationBecameAvailable;
- (void)registerForLocationNotifications;

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
//@synthesize locationManager = _locationManager;
//@synthesize userCoordinate = _userCoordinate;
//@synthesize shopInfos = _shopInfos;

#pragma mark - Setters, late instantiation

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

//- (CLLocationManager *)locationManager {
//    if (_locationManager == nil) {
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locationManager.distanceFilter = 100;
//    }
//    return _locationManager;
//}

#pragma mark - View Controller Life Cycle

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
    NSLog(@"viewDidLoad");
    
    NSLog(@"AuthorizationStatus = %d",[CLLocationManager authorizationStatus]);
    
    [self.shopListMapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
    
//    NSLog(@"%d", [BKShopInfoManager sharedBKShopInfoManager].shopInfos.count);    
    if ([BKShopInfoManager sharedBKShopInfoManager].shopCount == 0) {
//        self.isLoadingNewData = YES;
//        [self.locationManager startUpdatingLocation];
        
        [self reloadDataAccordingToListCriteria:BKListCriteriaDistant];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForLocationNotifications];
    [self.shopListTableView deselectRowAtIndexPath:[self.shopListTableView indexPathForSelectedRow] animated:YES];    
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"shopDetailSegue"]) {
        NSInteger selectedIndex = [self.shopListTableView indexPathForSelectedRow].row;
        BKShopDetailViewController *shopDetailViewController = segue.destinationViewController;
//        shopDetailViewController.navigationItem.title = [[BKShopInfoManager sharedBKShopInfoManager] shopNameAtIndex:selectedIndex];
        shopDetailViewController.shopInfo = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoAtIndex:selectedIndex];
    }
}

#pragma mark - Location notification

- (void)registerForLocationNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange) name:kBKLocationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationBecameAvailable) name:kBKLocationBecameAvailableNotification object:nil];
}

- (void)locationDidChange {
    NSLog(@"location changed: long %f, lat %f", [BKAPIManager sharedBKAPIManager].userCoordinate.longitude, [BKAPIManager sharedBKAPIManager].userCoordinate.latitude);
}

- (void)locationBecameAvailable {
    [self reloadDataAccordingToListCriteria:BKListCriteriaDistant];
}

#pragma mark - Utility methods

- (void)saveShopInfosWithShopIDs:(NSArray *)shopIDs {
//    [[BKShopInfoManager sharedBKShopInfoManager] clearShopInfos];
    
#warning Test shops inserted here
    // Test        
    NSArray *testShopInfos = [BKTestCenter testShopInfos];
    NSArray *testShopIDs = @[@"10", @"20", @"30"];
//    [BKShopInfoManager sharedBKShopInfoManager].shopInfos = [testShopInfos mutableCopy];
//    for (NSDictionary *shopInfo in testShopInfos) {
//        [[BKShopInfoManager sharedBKShopInfoManager] addShopInfoWithRawData:shopInfo];
////        NSLog(@"%@", shopInfo);
//    }
    [[BKShopInfoManager sharedBKShopInfoManager] updateShopIDs:testShopIDs];
    for (int i = 0; i < testShopIDs.count; i++) {
        [[BKShopInfoManager sharedBKShopInfoManager] addShopInfoWithRawData:[testShopInfos objectAtIndex:i] forShopID:[testShopIDs objectAtIndex:i]];
    }
    // End of Test]
    
//    for (NSString *shopID in shopIDs) {
//       [[BKAPIManager sharedBKAPIManager] shopDetailWithShopID:shopID completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//           
//       }];
//    }
//    NSLog(@"%@", [BKShopInfoManager sharedBKShopInfoManager].shopInfos);
    [self.shopListTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    //            [self.shopListTableView reloadData:YES];    
}

- (void)reloadDataAccordingToListCriteria:(BKListCriteria)criteria {
//    self.isLoadingNewData = YES;
    [[BKShopInfoManager sharedBKShopInfoManager] clearShopIDs];
    [self.shopListTableView reloadData];
    
    [[BKAPIManager sharedBKAPIManager] listWithListCriteria:criteria
                                          completionHandler:^(NSURLResponse *response, id data, NSError *error) {
                                              NSLog(@"%@", data);
//                                              self.isLoadingNewData = NO;                                              
                                              [self saveShopInfosWithShopIDs:data];
                                          }];
    
//    if (criteria == BKListCriteriaDistant) {
//        [self.locationManager startUpdatingLocation];
//    }
//    else if (criteria == BKListCriteriaPrice || criteria == BKListCriteriaScore){
//        [[BKAPIManager sharedBKAPIManager] listWithListCriteria:criteria
//                                              completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//                                                  NSLog(@"%@", data);
//                                                  self.isLoadingNewData = NO;
//                                                  [self saveShopInfosWithShopIDs:data];
//                                              }];
//    }     
}

#pragma mark - TableViewDataSource, TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
//    if (self.isLoadingNewData == YES) {
//        if (self.isLocationServiceEnabled == NO || [CLLocationManager locationServicesEnabled] == NO) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"noServiceCell"];
//        }
//        else {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell"];
//        }        
//    }
//    else if ([BKShopInfoManager sharedBKShopInfoManager].shopCount == 0){
//         
//            cell = [tableView dequeueReusableCellWithIdentifier:@"noResultCell"];            
//    }
//    else {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//            cell.textLabel.text = [[BKShopInfoManager sharedBKShopInfoManager] shopNameAtIndex:indexPath.row];
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
//    }
    
    if ([BKAPIManager sharedBKAPIManager].isLocationServiceAvailable == NO) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"noServiceCell"];
    }
    else if ([BKAPIManager sharedBKAPIManager].isLoadingData == YES){
        cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell"];
    }
    else if ([BKShopInfoManager sharedBKShopInfoManager].shopCount == 0){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"noResultCell"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = [[BKShopInfoManager sharedBKShopInfoManager] shopNameAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    }  
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.isLoadingNewData == YES) {
//        return 1;
//    }
    if ([BKAPIManager sharedBKAPIManager].isLocationServiceAvailable == NO) {        
        return 1;
    }
    else if ([BKAPIManager sharedBKAPIManager].isLoadingData == YES) {        
        return 1;
    }
    else if ([[BKShopInfoManager sharedBKShopInfoManager] shopCount] == 0) {
        return 1;
    }
    
    return [[BKShopInfoManager sharedBKShopInfoManager] shopCount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"cell"]) {
        [self performSegueWithIdentifier:@"shopDetailSegue" sender:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - Mapview delegate

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    self.locateUserButton.enabled = !(mode == MKUserTrackingModeFollow);
}

//- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
//    NSLog(@"123");
//}
//
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    NSLog(@"%@", userLocation);
//}

//#pragma mark - CLLocationManager delegate
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    self.isLocationServiceEnabled = YES;
//    [self.shopListTableView reloadData];
//    
//    CLLocation *location = [locations lastObject];
//    NSDate *eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
//        NSLog(@"longitude: %f, latitude:%f", location.coordinate.longitude, location.coordinate.latitude);
//        self.userCoordinate = location.coordinate;
//        [[BKAPIManager sharedBKAPIManager] listWithListCriteria:BKListCriteriaDistant completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//            NSLog(@"%@", data);
//            
//            self.isLoadingNewData = NO;
//            [self saveShopInfosWithShopIDs:data];
//        }];
//        [manager stopUpdatingLocation];
//    }
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"LocationManager failed with error :%@", error);
//    self.isLocationServiceEnabled = NO;
//    [self.shopListTableView reloadData];
//}

#pragma mark - Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"action sheet = %@", actionSheet);
//    NSLog(@"buttonIndex = %d", buttonIndex);
    if (actionSheet == self.listActionSheet) {
        switch (buttonIndex) {
            case BKListActionSheetButtonIndexDistant:
                [self reloadDataAccordingToListCriteria:BKListCriteriaDistant];
                break;
            case BKListActionSheetButtonIndexPrice:
                [self reloadDataAccordingToListCriteria:BKListCriteriaPrice];
                break;
            case BKListActionSheetButtonIndexScore:
                [self reloadDataAccordingToListCriteria:BKListCriteriaScore];
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
        [[BKAPIManager sharedBKAPIManager] searchWithShopName:self.searchBar.text completionHandler:^(NSURLResponse *response, id data, NSError *error) {
            NSLog(@"%@", data);
        }];
    }
}
@end
