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
#import "BKOrderManager.h"
#import "BKShopInfo.h"
#import "UIViewController+BKBaseViewController.h"
#import "BKShopListCell.h"

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

//typedef enum  {
//    BKListActionSheetButtonIndexDistant = 0,
//    BKListActionSheetButtonIndexPrice = 1,
//    BKListActionSheetButtonIndexScore = 2
//}BKListActionSheetButtonIndex;

typedef enum  {
    BKReloadMethodList = 0,
    BKReloadMethodSort = 1,
}BKReloadMethod;

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
//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITextField *searchBar;

@property (strong, nonatomic) UIActionSheet *listActionSheet;
@property (strong, nonatomic) UIActionSheet *sortActionSheet;
//@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (nonatomic) CLLocationCoordinate2D userCoordinate;
//@property (nonatomic) BOOL isLoadingNewData;
//@property (nonatomic) BOOL isLocationServiceEnabled;

//@property (strong, nonatomic) NSMutableArray *shopInfos;

- (void)saveTestShopInfosWithShopIDs:(NSArray *)shopIDs;
// Methods for reloading data based on list criteria
//- (void)reloadDataAccordingToListCriteria:(BKListCriteria)criteria;
- (void)reloadDataUsing:(BKReloadMethod)method criteria:(NSInteger)criteria;
- (void)reloadDefault;

- (void)locationDidChange;
- (void)locationBecameAvailable;
- (void)serverInfoDidUpdate;
- (void)registerNotifications;

- (NSString *)currencyStringForPrice:(NSNumber *)price;
- (NSString *)stringForDeliverCost:(NSNumber *)cost;
- (NSString *)stringForDistanceFrom:(CLLocation *)shopLocation;

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
        _listActionSheet = [[UIActionSheet alloc] initWithTitle:@"排序" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        NSArray *listCriterias = [BKAPIManager sharedBKAPIManager].localizedListCriteria;
        for (NSString *theCriteria in listCriterias) {
            [_listActionSheet addButtonWithTitle:theCriteria];
        }
        _listActionSheet.cancelButtonIndex = [_listActionSheet addButtonWithTitle:@"取消"];
        [_listActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return _listActionSheet;
}

- (UIActionSheet *)sortActionSheet {
    if (_sortActionSheet == nil) {
        _sortActionSheet = [[UIActionSheet alloc] initWithTitle:@"分類" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        NSArray *sortCriterias = [BKAPIManager sharedBKAPIManager].sortCriteria;
        for (NSString *theCriteria in sortCriterias) {
            [_sortActionSheet addButtonWithTitle:theCriteria];
        }
        _sortActionSheet.cancelButtonIndex = [_sortActionSheet addButtonWithTitle:@"取消"];
        [_sortActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }    
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
    NSLog(@"viewDidLoad");    
    NSLog(@"AuthorizationStatus = %d",[CLLocationManager authorizationStatus]);   
    
    [self.shopListMapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];    
   
    if ([BKShopInfoManager sharedBKShopInfoManager].shopCount == 0) {        
//        [self reloadDataAccordingToListCriteria:BKListCriteriaDistant];
        [self reloadDefault];
    }

    [self.bottomToolBar setBackgroundImage:[UIImage imageNamed:@"under"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.mainContentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
}

//- (void)pop {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotifications];
    NSIndexPath *selectedIndexPath = [self.shopListTableView indexPathForSelectedRow];
    if (selectedIndexPath != nil) {
        [self.shopListTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
//    if (selectedIndexPath != nil) {
//        NSLog(@"selectedIndexPath :%@", [self.shopListTableView indexPathForSelectedRow]);
//        NSArray *indexPathsToBeReloaded = [self.shopListTableView indexPathsForVisibleRows];
//        [self.shopListTableView reloadRowsAtIndexPaths:indexPathsToBeReloaded withRowAnimation:UITableViewRowAnimationNone];
////        [self.shopListTableView reloadData];
//        [self.shopListTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        [self.shopListTableView deselectRowAtIndexPath:[self.shopListTableView indexPathForSelectedRow] animated:YES];
//    }
//    NSLog(@"visible rows: %@",[self.shopListTableView indexPathsForVisibleRows]);
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
        shopDetailViewController.shopID = [[BKShopInfoManager sharedBKShopInfoManager] shopIDAtIndex:selectedIndex];
    }
}

#pragma mark - Location notification

- (void)locationDidChange {
    NSLog(@"location changed: long %f, lat %f", [BKAPIManager sharedBKAPIManager].userLocation.coordinate.longitude, [BKAPIManager sharedBKAPIManager].userLocation.coordinate.latitude);
}

- (void)locationBecameAvailable {
    NSLog(@"locationBecameAvailable");
    [self reloadDefault];
}

#pragma mark - Server info notification

- (void)serverInfoDidUpdate {
    NSLog(@"server info did update!");
//    if (self.listActionSheet.visible) {
//        [self.listActionSheet dismissWithClickedButtonIndex:self.listActionSheet.cancelButtonIndex animated:YES];
//    }
//    if (self.sortActionSheet.visible) {
//        [self.sortActionSheet dismissWithClickedButtonIndex:self.sortActionSheet.cancelButtonIndex animated:YES];
//    }
    self.listActionSheet = nil;
    self.sortActionSheet = nil;
    
    [self reloadDefault];
}

#pragma mark - Utility methods

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange) name:kBKLocationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationBecameAvailable) name:kBKLocationBecameAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverInfoDidUpdate) name:kBKServerInfoDidUpdateNotification object:nil];
}

- (void)saveTestShopInfosWithShopIDs:(NSArray *)shopIDs {
//    [[BKShopInfoManager sharedBKShopInfoManager] clearShopInfos];
    
#warning Test shops inserted here
    // Test        
    NSArray *testShopInfos = [BKTestCenter testShopInfos];
    NSArray *testShopIDs = @[@"1000", @"2000", @"3000"];

    [[BKShopInfoManager sharedBKShopInfoManager] updateShopIDs:testShopIDs];
    for (int i = 0; i < testShopIDs.count; i++) {
        [[BKShopInfoManager sharedBKShopInfoManager] addShopInfoWithRawData:[testShopInfos objectAtIndex:i] forShopID:[testShopIDs objectAtIndex:i]];

    }
    // End of Test]
    
//    [[BKShopInfoManager sharedBKShopInfoManager] updateShopIDs:shopIDs];
//    for (NSString *shopID in shopIDs) {
//       [[BKAPIManager sharedBKAPIManager] shopDetailWithShopID:shopID completionHandler:^(NSURLResponse *response, id data, NSError *error) {
//           
//       }];
//        NSLog(@"shopID: %@", shopID);
//    }

    [self.shopListTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];   
}

//- (void)reloadDataAccordingToListCriteria:(BKListCriteria)criteria {
////    self.isLoadingNewData = YES;
//    [[BKShopInfoManager sharedBKShopInfoManager] clearShopIDs];
//    [self.shopListTableView reloadData];
//    
////    [[BKAPIManager sharedBKAPIManager] listWithListCriteria:criteria
////                                          completionHandler:^(NSURLResponse *response, id data, NSError *error) {
////                                              NSLog(@"%@", data);
//////                                              self.isLoadingNewData = NO;                                              
////                                              [self saveShopInfosWithShopIDs:data];
////                                          }];
////    [self saveTestShopInfosWithShopIDs:nil];
//    
//    [[BKAPIManager sharedBKAPIManager] loadDataWithListCriteria:criteria
//                                                completeHandler:^(NSArray *shopIDs, NSArray *shopRawDatas) {
//        
//        NSLog([[BKAPIManager sharedBKAPIManager] isLoadingData]? @"API is loading data" : @"API is NOT loading data");
//                                                    NSLog(@"shopIDs: %@", shopIDs);
////                                                    NSLog(@"shopRawDatas: %@", shopRawDatas);
//                                                    [[BKShopInfoManager sharedBKShopInfoManager] updateShopIDs:shopIDs];
//                                                    [[BKShopInfoManager sharedBKShopInfoManager] addShopInfosWithRawDatas:shopRawDatas forShopIDs:shopIDs];
//                                                    [self.shopListTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
////                                                    [[BKShopInfoManager sharedBKShopInfoManager] printShopIDs];
//                                                }];
//}

- (void)reloadDataUsing:(BKReloadMethod)method criteria:(NSInteger)criteria {
    
    [[BKShopInfoManager sharedBKShopInfoManager] clearShopIDs];
    [self.shopListTableView reloadData];
    
    void (^handler)(NSArray *shopIDs, NSArray *shopRawDatas) = ^(NSArray *shopIDs, NSArray *shopRawDatas) {
        NSLog([[BKAPIManager sharedBKAPIManager] isLoadingData]? @"API is loading data" : @"API is NOT loading data");
        NSLog(@"shopIDs: %@", shopIDs);
        //                                                    NSLog(@"shopRawDatas: %@", shopRawDatas);
        [[BKShopInfoManager sharedBKShopInfoManager] updateShopIDs:shopIDs];
        [[BKShopInfoManager sharedBKShopInfoManager] addShopInfosWithRawDatas:shopRawDatas forShopIDs:shopIDs];
        [self.shopListTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        //                                                    [[BKShopInfoManager sharedBKShopInfoManager] printShopIDs];
    };
    
    switch (method) {
        case BKReloadMethodList:
            [[BKAPIManager sharedBKAPIManager] loadDataWithListCriteria:criteria completeHandler:handler];
            break;
            
        case BKReloadMethodSort:
            [[BKAPIManager sharedBKAPIManager] loadDataWithSortCriteria:criteria completeHandler:handler];
            break;
        default:
            NSLog(@"Warning: invalid reload method!");
            break;
    }
    
    // The folling line is for testing
//    [self saveTestShopInfosWithShopIDs:nil];
}

- (void)reloadDefault {
    [self reloadDataUsing:BKReloadMethodList criteria:0];
}

- (NSString *)currencyStringForPrice:(NSNumber *)price {
    static NSNumberFormatter *currencyFormatter;
    
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setPositiveFormat:@"¤#,###"];
        NSLocale *twLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"];
        [currencyFormatter setLocale:twLocale];
        [currencyFormatter setCurrencySymbol:@"$"];
        //        NSLog(@"positive format: %@", [currencyFormatter positiveFormat]);
    }
    
    return [currencyFormatter stringFromNumber:price];
}

- (NSString *)stringForDeliverCost:(NSNumber *)cost {
    return [NSString stringWithFormat:@"%@免費外送", [self currencyStringForPrice:cost]];
}

- (NSString *)stringForDistanceFrom:(CLLocation *)shopLocation {
    CLLocation *userLocation = [BKAPIManager sharedBKAPIManager].userLocation;
    CLLocationDistance distance = [userLocation distanceFromLocation:shopLocation];
    
    if (distance > 1000.0) {
        distance = distance/1000.0;
        return [NSString stringWithFormat:@"距離%0.1f公里", distance];
    }
    
    return [NSString stringWithFormat:@"距離%d公尺", (NSInteger)distance];
}

#pragma mark - TableViewDataSource, TableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([BKAPIManager sharedBKAPIManager].isLocationServiceAvailable == NO) {
//        return 44;
//    }
//    else if ([BKAPIManager sharedBKAPIManager].isLoadingData == YES){
//        return 44;
//    }
//    else if ([BKShopInfoManager sharedBKShopInfoManager].shopCount == 0){        
//        return 44;
//    }
//    else {
//        return 86;        
//    }
//}

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
        BKShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

        UIImage *backgroundImage = [UIImage imageNamed:@"list"];
        UIImage *pressImage = [UIImage imageNamed:@"list_press"];
        UIImage *picture = [UIImage imageNamed:@"picture"];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:pressImage];
        cell.imageView.image = picture;       
        
        BKShopInfo *theShopInfo = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoAtIndex:indexPath.row];
        
        // Configure shop name
        cell.shopNameLabel.text = theShopInfo.name;       
        
        // Configure deliver price and distance
        CLLocation *shopLocation = theShopInfo.shopLocaiton;
        NSString *deliverCostAndDistanceString = [NSString stringWithFormat:@"%@，%@", [self stringForDeliverCost:theShopInfo.deliverCost], [self stringForDistanceFrom:shopLocation]];
        cell.priceAndDistanceLabel.text = deliverCostAndDistanceString;
        
        // Configure commerce type
        cell.commerceTypeLabel.text = theShopInfo.commerceType;
        
        // Configure score
        NSInteger shopScore = 4;        
        if (shopScore <= ((BKShopListCell *)cell).scoreImageViews.count) {            
            for (NSInteger i = 0; i < shopScore; i++) {                
                UIImageView *scoreImageView = [((BKShopListCell *)cell).scoreImageViews objectAtIndex:i];
                scoreImageView.image = [UIImage imageNamed:@"star_press"];
            }
        }        
        
//        NSLog(@"shopID :%@", theShopInfo.shopID);
//        NSLog(@"order shopID: %@", [[BKOrderManager sharedBKOrderManager] shopID]);
//        if ([[[BKOrderManager sharedBKOrderManager] shopID] isEqualToString:theShopInfo.shopID]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
        return cell;
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

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
//
//-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

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
//        switch (buttonIndex) {
//            case BKListActionSheetButtonIndexDistant:
////                [self reloadDataAccordingToListCriteria:BKListCriteriaDistant];
//                [self reloadDataUsing:BKReloadMethodList criteria:BKListCriteriaDistant];
//                break;
//            case BKListActionSheetButtonIndexPrice:
////                [self reloadDataAccordingToListCriteria:BKListCriteriaPrice];
//                [self reloadDataUsing:BKReloadMethodList criteria:BKListCriteriaPrice];
//                break;
//            case BKListActionSheetButtonIndexScore:
////                [self reloadDataAccordingToListCriteria:BKListCriteriaScore];
//                [self reloadDataUsing:BKReloadMethodList criteria:BKListCriteriaScore];
//                break;
//            default:                
//                break;
//        }
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            [self reloadDataUsing:BKReloadMethodList criteria:buttonIndex];
        }    
    }
    else if (actionSheet == self.sortActionSheet) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            [self reloadDataUsing:BKReloadMethodSort criteria:buttonIndex];
        }    
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
    return;
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
    [self.searchBar resignFirstResponder];
}
@end
