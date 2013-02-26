//
//  BKShopDetailViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/1.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopDetailViewController.h"
#import "BKMainPageViewController.h"
#import "BKShopInfo.h"
#import "BKMenuViewController.h"
#import "BKMakeOrderViewController.h"

@interface BKShopDetailViewController ()

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)orderDeliverButtonPressed:(id)sender;
- (IBAction)takeAwayButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopOpenTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *discountInformation;

- (void)initShop;

@end

@implementation BKShopDetailViewController

@synthesize shopInfo = _shopInfo;

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
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = ((BKMainPageViewController *)[self.navigationController.viewControllers objectAtIndex:0]).homeButton;
    self.navigationItem.title = self.shopInfo.name;
    [self initShop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"menuSegue"]) {
        BKMenuViewController *menuVC = segue.destinationViewController;
        menuVC.navigationItem.title = [self.shopInfo.name stringByAppendingString:@"的菜單"];
        menuVC.menu = self.shopInfo.menu;
    }
    else if ([segue.identifier isEqualToString:@"makeOrderSegue"]) {
        BKMakeOrderViewController *makeOrderVC = segue.destinationViewController;
//        makeOrderVC.menu = self.shopInfo.menu;
        makeOrderVC.shopInfo = self.shopInfo;
    }
}

- (void)initShop {
    self.shopNameLabel.text = self.shopInfo.name;
    self.shopAddressLabel.text = self.shopInfo.address;
    self.shopPhoneLabel.text = self.shopInfo.phone;
    self.shopOpenTimeLabel.text = self.shopInfo.openHours;
    self.discountInformation.text = self.shopInfo.shopDescription;
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    if(editing == YES){
//        self.editButtonItem.title = @"完成";
//    }else {
//        self.editButtonItem.title = @"編輯";
//    }
//}

- (IBAction)menuButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"menuSegue" sender:self];
}

- (IBAction)orderDeliverButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"makeOrderSegue" sender:self];
}

- (IBAction)takeAwayButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"makeOrderSegue" sender:self];
}
@end
