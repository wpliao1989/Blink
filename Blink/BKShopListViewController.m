//
//  shopListViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopListViewController.h"

@interface BKShopListViewController ()

- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)mapButtonPressed:(id)sender;
- (IBAction)listButtonPressed:(id)sender;
- (IBAction)sortButtonPressed:(id)sender;
- (IBAction)categoryButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *mainContentView;
@property (strong, nonatomic) IBOutlet MKMapView *shopListMapView;
@property (strong, nonatomic) IBOutlet UITableView *shopListTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sortButton;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@end

@implementation BKShopListViewController

@synthesize mainContentView = _mainContentView;
@synthesize mapButton = _mapButton;
@synthesize listButton = _listButton;
@synthesize sortButton = _sortButton;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize shopListMapView = _shopListMapView;
@synthesize shopListTableView = _shopListTableView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource, TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - IBActions

- (IBAction)homeButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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
    }];
}

- (IBAction)listButtonPressed:(id)sender {
//    [UIView transitionFromView:self.testView toView:self.mainContentView duration:1.0 options: UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//        
//    }];
    self.listButton.enabled = NO;
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
    UIActionSheet *sortSheet = [[UIActionSheet alloc] initWithTitle:@"排序" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"依距離", @"依價格", @"依評價", nil];
    [sortSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sortSheet showInView:self.mainContentView];
}

- (IBAction)categoryButtonPressed:(id)sender {
    UIActionSheet *categorySheet = [[UIActionSheet alloc] initWithTitle:@"分類" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"飲料", @"中式", @"西式", nil];
    [categorySheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [categorySheet showInView:self.mainContentView];
}
@end
