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
#import "BKShopInfoForUser.h"
#import "UIViewController+BKBaseViewController.h"
#import "BKShopListCell.h"
#import "MKMapView+AnnotationOperation.h"
#import "NSString+MKCoordinateRegion.h"
#import "BKSearchOption.h"
#import "BKSearchParameter.h"
#import "UIViewController+Formatter.h"
#import "UIViewController+ShopListCell.h"
#import "UIViewController+SharedCustomizedUI.h"

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

NSString *const kOffsetKeyReachEnd = @"com.flyingman.kOffsetKeyReachEnd";

@interface BKShopListViewController ()

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
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) UIActionSheet *listActionSheet;
@property (strong, nonatomic) UIActionSheet *sortActionSheet;

- (void)saveTestShopInfosWithShopIDs:(NSArray *)shopIDs;

// Current search method
@property (nonatomic) BKSearchOption currentSearchOption;
// Methods for reloading data based on list criteria
//- (void)reloadDataAccordingToListCriteria:(BKListCriteria)criteria;
- (void)reloadDataUsingListWithActionSheetIndex:(NSUInteger)index;
- (void)reloadDataUsingSortWithActionSheetIndex:(NSUInteger)index;
- (void)reloadDataUsingSearchWithShopName:(NSString *)shopName;
- (void)reloadDataUsing:(BKSearchOption)method parameter:(BKSearchParameter *)parameter;
- (void)reloadDefault;
- (void)loadMoreData;
- (void)updateMapViewRegion;
- (void)downloadImageForShopInfo:(BKShopInfoForUser *)shopInfo;

- (void)locationDidChange;
- (void)locationBecameAvailable;
- (void)serverInfoDidUpdate;
- (void)registerNotifications;

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

#pragma mark - Setters, late instantiation

- (BKSearchParameter *)searchParameter {
    if (_searchParameter == nil) {
        _searchParameter = [[BKSearchParameter alloc] init];
    }
    return _searchParameter;
}

- (UIActionSheet *)listActionSheet {
    if (_listActionSheet == nil) {
        _listActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Ordering", @"排序") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        NSArray *listCriterias = [BKAPIManager sharedBKAPIManager].localizedListCriteria;
        for (NSString *theCriteria in listCriterias) {
            [_listActionSheet addButtonWithTitle:theCriteria];
        }
        _listActionSheet.cancelButtonIndex = [_listActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        [_listActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return _listActionSheet;
}

- (UIActionSheet *)sortActionSheet {
    if (_sortActionSheet == nil) {       
        _sortActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Sort", @"分類") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        NSArray *sortCriterias = [BKAPIManager sharedBKAPIManager].localizedSortCriteria;        
        for (NSString *theCriteria in sortCriterias) {
            [_sortActionSheet addButtonWithTitle:theCriteria];
        }
        _sortActionSheet.cancelButtonIndex = [_sortActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        [_sortActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }    
    return _sortActionSheet;
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    NSLog(@"self.search parameter=%@", self.searchParameter);
    NSLog(@"AuthorizationStatus = %d",[CLLocationManager authorizationStatus]);   
    
    [self setUpMapView];
    [self setUpTableView];
    [self setUpCustomAppearance];
}

- (void)setUpMapView {
    [self.shopListMapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
    [self.shopListMapView addAnnotations:[[BKShopInfoManager sharedBKShopInfoManager] annotations]];
}

- (void)setUpTableView {
    [self.shopListTableView registerNib:[UINib nibWithNibName:@"BKShopListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    //    if ([BKShopInfoManager sharedBKShopInfoManager].shopCount == 0) {
    ////        [self reloadDataAccordingToListCriteria:BKListCriteriaDistant];
    //        [self reloadDefault];
    //    }
    [self reloadDefault];
}

- (void)setUpCustomAppearance {
    [self.bottomToolBar setBackgroundImage:[UIImage imageNamed:@"under"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.mainContentView setBackgroundColor:[self viewBackgoundColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotifications];
    NSIndexPath *selectedIndexPath = [self.shopListTableView indexPathForSelectedRow];
    if (selectedIndexPath != nil) {
        [self.shopListTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
    NSLog(@"map annotations: %@", self.shopListMapView.annotations);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"shopDetailSegue"]) {
        if ([sender isKindOfClass:[BKShopInfoForUser class]]) {
            BKShopInfoForUser *shopInfo = sender;
            //NSInteger selectedIndex = [self.shopListTableView indexPathForSelectedRow].row;
            BKShopDetailViewController *shopDetailViewController = segue.destinationViewController;
            //        shopDetailViewController.navigationItem.title = [[BKShopInfoManager sharedBKShopInfoManager] shopNameAtIndex:selectedIndex];
            //NSString *shopID = [[BKShopInfoManager sharedBKShopInfoManager] shopIDAtIndex:selectedIndex];
            NSString *shopID = shopInfo.sShopID;
            shopDetailViewController.shopID = shopID;
        }
        
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

#pragma mark - Reload Data

- (void)reloadDataUsingListWithActionSheetIndex:(NSUInteger)index {
    self.currentSearchOption = BKSearchOptionList;
    self.searchParameter.criteria = index;
    [self reloadDataUsing:BKSearchOptionList parameter:self.searchParameter];
}

- (void)reloadDataUsingSortWithActionSheetIndex:(NSUInteger)index {
    self.currentSearchOption = BKSearchOptionSort;
    self.searchParameter.criteria = index;
    [self reloadDataUsing:BKSearchOptionSort parameter:self.searchParameter];
}

- (void)reloadDataUsingSearchWithShopName:(NSString *)shopName {
    self.currentSearchOption = BKSearchOptionSearch;
    self.searchParameter.shopName = shopName;
    [self reloadDataUsing:BKSearchOptionSearch parameter:self.searchParameter];    
}

- (void)reloadDataUsing:(BKSearchOption)method parameter:(BKSearchParameter *)parameter{
    // Reset tableView and mapView
    [[BKShopInfoManager sharedBKShopInfoManager] clearShopIDs];
    [self.shopListTableView reloadData];
    [self.shopListMapView removeAnnotations:self.shopListMapView.annotations withoutUser:YES];
    
    // Reset offset to nil
    parameter.offset = nil;
    
    // Load new data
    [self loadDataUsing:method parameter:parameter];
}

- (void)reloadDefault {
    [self reloadDataUsingListWithActionSheetIndex:0];
}

- (void)loadMoreData {
    if (![self.searchParameter.offset isEqualToString:kOffsetKeyReachEnd]) {
        [self loadDataUsing:self.currentSearchOption parameter:self.searchParameter];
    }
}

// Helper method for calling BKShopInfoManager's | loadDataOption: parameter: completeHandler: |
- (void)loadDataUsing:(BKSearchOption)method parameter:(BKSearchParameter *)parameter {
    [[BKShopInfoManager sharedBKShopInfoManager] loadDataOption:method parameter:parameter completeHandler:^(BOOL success, NSString *key) {
        NSLog([[BKAPIManager sharedBKAPIManager] isLoadingData]? @"API is loading data" : @"API is NOT loading data");
        
        // Update tableView
        [self.shopListTableView reloadData];
        //[self.shopListTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
        // Update mapView
        [self.shopListMapView addAnnotations:[[BKShopInfoManager sharedBKShopInfoManager] annotations]];
        NSLog(@"map annotations: %@", self.shopListMapView.annotations);
        if (self.shopListMapView.hidden == NO) {
            [self updateMapViewRegion];
        }
        
        // Save offset key
        if (key) {
            self.searchParameter.offset = key;
        }
        else {
            self.searchParameter.offset = kOffsetKeyReachEnd;
        }
        
    }];
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

// The folloing is for older version API
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

//- (void)reloadDataUsing:(BKReloadMethod)method criteria:(NSInteger)criteria {
//    
//    [[BKShopInfoManager sharedBKShopInfoManager] clearShopIDs];
//    [self.shopListTableView reloadData];
//    
//    loadDataCompleteHandler handler = ^(NSArray *shopIDs, NSArray *shopRawDatas) {
//        NSLog([[BKAPIManager sharedBKAPIManager] isLoadingData]? @"API is loading data" : @"API is NOT loading data");
//        NSLog(@"shopIDs: %@", shopIDs);
//        //                                                    NSLog(@"shopRawDatas: %@", shopRawDatas);
//        [[BKShopInfoManager sharedBKShopInfoManager] updateShopIDs:shopIDs];
//        [[BKShopInfoManager sharedBKShopInfoManager] addShopInfosWithRawDatas:shopRawDatas forShopIDs:shopIDs];
//        [self.shopListTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//        //                                                    [[BKShopInfoManager sharedBKShopInfoManager] printShopIDs];
//    };
//    
//    switch (method) {
//        case BKReloadMethodList:
//            [[BKAPIManager sharedBKAPIManager] loadDataWithListCriteria:criteria completeHandler:handler];
//            break;
//            
//        case BKReloadMethodSort:
//            [[BKAPIManager sharedBKAPIManager] loadDataWithSortCriteria:criteria completeHandler:handler];
//            break;
//        default:
//            NSLog(@"Warning: invalid reload method!");
//            break;
//    }
//    
//    // The folling line is for testing
////    [self saveTestShopInfosWithShopIDs:nil];
//}

- (void)downloadImageForShopInfo:(BKShopInfoForUser *)shopInfo {
    [[BKShopInfoManager sharedBKShopInfoManager] downloadImageForShopInfo:shopInfo completeHandler:^(UIImage *image) {
        
        NSUInteger indexForShop = [[BKShopInfoManager sharedBKShopInfoManager] indexForShopID:shopInfo.sShopID];
        
        if ( indexForShop != NSNotFound) {
            // Configure table view
            UITableViewCell *cell = [self.shopListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexForShop inSection:0]];
            [self setImageView:cell.imageView withImage:image];
            
            // Configure map view
            if (self.shopListMapView.hidden == NO) {
                MKAnnotationView *view = [self.shopListMapView viewForAnnotation:shopInfo];
                if (view) {
                    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
                        [self setImageView:imageView withImage:image];
                    }
                }
            }
            
            NSLog(@"Shop list: image did download! %@", shopInfo.name);
        }
    }];
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
        BKShopInfoForUser *theShopInfo = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoAtIndex:indexPath.row];
        [self configureShopListCell:cell withShopInfo:theShopInfo];
        
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
        BKShopInfoForUser *shopInfo = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"shopDetailSegue" sender:shopInfo];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![cell.reuseIdentifier isEqualToString:@"cell"]) {
        return;
    }
    BKShopInfoForUser *theShopInfo = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoAtIndex:indexPath.row];
    
    NSLog(@"will display cell at row:%d", indexPath.row);
    NSLog(@"cell image: %@", cell.imageView.image);
    NSLog(@"shop info image: %@", theShopInfo.pictureImage);
    
    if (cell.imageView.image == nil || cell.imageView.image == [self defaultPicture]) {
        
        [self downloadImageForShopInfo:theShopInfo];

        // Test image
//        NSURLRequest *request = [NSURLRequest requestWithURL:theShopInfo.pictureURL];
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//            //            NSLog(@"pic response: %@", response);
//            //            NSLog(@"pic data: %@", data);
//            //            NSLog(@"pic error: %@", error);
//            UIImage *pic = [UIImage imageWithData:data];
//            cell.imageView.image = pic;
//            theShopInfo.pictureImage = pic;
//        }];
    }
    
    if (indexPath.row == [[BKShopInfoManager sharedBKShopInfoManager] shopCount] - 1) {
        [self loadMoreData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - Mapview delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[BKShopInfoForUser class]]) {
        BKShopInfoForUser *shopInfo = view.annotation;
        [self performSegueWithIdentifier:@"shopDetailSegue" sender:shopInfo];
    }    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        BKShopInfoForUser *shopInfo = view.annotation;
        if (shopInfo.pictureImage == nil) {
            imageView.image = [self defaultPicture];
            [self downloadImageForShopInfo:shopInfo];
        }
        else {
            imageView.image = shopInfo.pictureImage;
        }        
    }
}

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    NSLog(@"region did changed!");
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *annotationViewID = @"annotationViewID";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (pinView == nil)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:annotationViewID];
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        // add a detail disclosure button to the callout which will open a new view controller page
        //
        // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
        //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
        //
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        customPinView.rightCalloutAccessoryView = rightButton;
        customPinView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
        return customPinView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    
    if ([pinView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(pinView.leftCalloutAccessoryView);
        imageView.image = nil;
    }
    
    return pinView;
}

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

#pragma mark - Update region

//
//- (void)updateMapViewRegion {
//    if ([[BKShopInfoManager sharedBKShopInfoManager] shopCount] <= 0) {
//        return;
//    }
//    
//    NSArray *visibleIndexPaths = [self.shopListTableView indexPathsForVisibleRows];    
//    NSMutableArray *visibleAnnotations = [NSMutableArray array];
//    for (NSIndexPath *indexpath in visibleIndexPaths) {
//        BKShopInfo *shopInfo = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoAtIndex:indexpath.row];
//        [visibleAnnotations addObject:shopInfo];  
//    }
//    
//    // Add user location
//    if (self.shopListMapView.userLocation) {
//        [visibleAnnotations addObject:self.shopListMapView.userLocation];
//    }
//    
//    CGRect boundingRect;
//    BOOL started = NO;
//    for (id <MKAnnotation> annotation in visibleAnnotations) {
//        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
//        if (!started) {
//            started = YES;
//            boundingRect = annotationRect;
//        } else {
//            boundingRect = CGRectUnion(boundingRect, annotationRect);
//        }
//    }
//    if (started) {
//        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
//        
//        CLLocationDegrees latitudeSpanLimit = 2.0;
//        CLLocationDegrees longitudeSpanLimit = 2.0;
//        
//        if ((boundingRect.size.width < latitudeSpanLimit) && (boundingRect.size.height < longitudeSpanLimit)) {
//            MKCoordinateRegion region;
//            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
//            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
//            region.span.latitudeDelta = boundingRect.size.width;
//            region.span.longitudeDelta = boundingRect.size.height;
//            [self.shopListMapView setRegion:region animated:YES];
//            
//            NSLog(@"Original region:%@, resized by map:%@", [NSString stringFromRegion:region],            [NSString stringFromRegion:[self.shopListMapView regionThatFits:region]]);
//        }
//    }    
//}

- (void)updateMapViewRegion {
    if ([[BKShopInfoManager sharedBKShopInfoManager] shopCount] <= 0) {
        return;
    }
    
    NSArray *visibleIndexPaths = [self.shopListTableView indexPathsForVisibleRows];
    NSMutableArray *visibleAnnotations = [NSMutableArray array];
    for (NSIndexPath *indexpath in visibleIndexPaths) {
        BKShopInfoForUser *shopInfo = [[BKShopInfoManager sharedBKShopInfoManager] shopInfoAtIndex:indexpath.row];
        [visibleAnnotations addObject:shopInfo];
    }
    
    // Add user location
    if (self.shopListMapView.userLocation) {
        [visibleAnnotations addObject:self.shopListMapView.userLocation];
    }
    
    // One degree is approximately 111km
    CLLocationDegrees latitudeSpanLimit = 0.1;
    CLLocationDegrees longitudeSpanLimit = 0.1;
    CLLocationDegrees latitudePadding = 0.01;
    CLLocationDegrees longitudePadding = 0.01;
    
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in visibleAnnotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            CGRect rectUnion = CGRectUnion(boundingRect, annotationRect);
            if ((rectUnion.size.width < latitudeSpanLimit) && (rectUnion.size.height < longitudeSpanLimit)) {
                boundingRect = CGRectUnion(boundingRect, annotationRect);
            }
        }
    }
    if (started) {        
        if ((boundingRect.size.width > 0) && (boundingRect.size.height > 0)) {
            boundingRect = CGRectInset(boundingRect, -latitudePadding, -longitudePadding);
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.shopListMapView setRegion:region animated:YES];
            
            NSLog(@"Original region:%@, resized by map:%@", [NSString stringFromRegion:region],            [NSString stringFromRegion:[self.shopListMapView regionThatFits:region]]);
        }
    }
}

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
            [self reloadDataUsingListWithActionSheetIndex:buttonIndex];
        }    
    }
    else if (actionSheet == self.sortActionSheet) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            [self reloadDataUsingSortWithActionSheetIndex:buttonIndex];
        }    
    }
}

#pragma mark - Search bar text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchButtonPressed:self.searchButton];
    return YES;
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
    [self.shopListTableView reloadData];
    
    [UIView transitionWithView:self.mainContentView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.shopListMapView.hidden = NO;
        self.shopListTableView.hidden = YES;
        
    } completion:^(BOOL finished) {
        
        NSMutableArray *bottomToolBarItems = [self.bottomToolBar.items mutableCopy];
        [bottomToolBarItems replaceObjectAtIndex:0 withObject:self.listButton];
        self.bottomToolBar.items = [NSArray arrayWithArray:bottomToolBarItems];
        self.mapButton.enabled = YES;
        self.navigationItem.rightBarButtonItem = self.locateUserButton;
        
        [self updateMapViewRegion];
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
        [self reloadDataUsingSearchWithShopName:self.searchBar.text];
    }
    [self.searchBar resignFirstResponder];
}
@end
