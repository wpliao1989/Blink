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
#import "BKShopInfoManager.h"
#import "BKMenuViewController.h"
#import "BKMakeOrderViewController.h"
#import "UIViewController+BKBaseViewController.h"

@interface BKShopDetailViewController ()

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)orderDeliverButtonPressed:(id)sender;
- (IBAction)takeAwayButtonPressed:(id)sender;

@property (nonatomic, strong) BKShopInfo *shopInfo;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *topSectionBackground;
@property (strong, nonatomic) IBOutlet UIImageView *introduceSectionBackground;
@property (strong, nonatomic) IBOutlet UIView *introSection;
@property (strong, nonatomic) IBOutlet UIView *bottomSection;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopCommerceTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopOpenTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *shopIntro;

- (BOOL)callPhoneNumberWithPhoneString:(NSString *)phoneNumber;
- (NSString *)phoneNumberExtractedFromString:(NSString *)string;

- (void)initShop;
- (void)configureIntroSection;
- (void)configureBottomSection;
- (void)configureScrollView;

@end

@implementation BKShopDetailViewController

@synthesize shopInfo = _shopInfo;

- (BKShopInfo *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
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
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = self.shopInfo.name;
    [self initShop];
    [self.topSectionBackground setImage:[[UIImage imageNamed:@"list_try"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 14, 67, 20)]];    

    [self configureIntroSection];
    [self configureBottomSection];
    [self configureScrollView];    
}

- (void)configureIntroSection {
    CGFloat shopIntroBottomPoint =  self.shopIntro.frame.origin.y + self.shopIntro.contentSize.height;
    CGFloat sectionHeight = shopIntroBottomPoint + 40.0;
    CGRect newFrame = self.introSection.frame;
    newFrame.size.height = sectionHeight;
    NSLog(@"old frame = %@", NSStringFromCGRect(self.introSection.frame));
    self.introSection.frame = newFrame;
    NSLog(@"new frame = %@", NSStringFromCGRect(self.introSection.frame));
    NSLog(@"height of text: %f", self.shopIntro.contentSize.height);
    [self.introduceSectionBackground setImage:[[UIImage imageNamed:@"introduce"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 158, 35, 158)]];
}

- (void)configureBottomSection {
    CGRect newFrame = self.bottomSection.frame;
    newFrame.origin.y = self.introSection.frame.origin.y + self.introSection.frame.size.height;
    self.bottomSection.frame = newFrame;
}

- (void)configureScrollView {
    CGFloat contentHeight = self.bottomSection.frame.origin.y + self.bottomSection.frame.size.height;
    [self.scrollView setContentSize:CGSizeMake(320, contentHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]];
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
//        makeOrderVC.shopInfo = self.shopInfo;
        makeOrderVC.shopID = self.shopID;
    }
}

- (void)initShop {
    self.shopNameLabel.text = self.shopInfo.name;
    self.shopCommerceTypeLabel.text = self.shopInfo.commerceType;
    self.shopAddressLabel.text = self.shopInfo.address;
    self.shopPhoneLabel.text = self.shopInfo.phone;
    self.shopOpenTimeLabel.text = self.shopInfo.openHours;
    self.shopIntro.text = self.shopInfo.shopDescription;
}

- (BOOL)callPhoneNumberWithPhoneString:(NSString *)phoneNumber {
    phoneNumber = [self phoneNumberExtractedFromString:phoneNumber];
    
    NSURL *phoneURL = [NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]];
    NSLog(@"phoneURL = %@", phoneURL);
//    NSLog([[UIApplication sharedApplication] canOpenURL:phoneURL] ? @"YES" : @"NO");
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
        return YES;
    }
    return NO;
}

- (NSString *)phoneNumberExtractedFromString:(NSString *)string {
    BOOL hasPlusSign = NO;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([[string substringToIndex:1] isEqualToString:@"+"]) {
        hasPlusSign = YES;
    }
    static NSCharacterSet *seperatorSet;
    if (seperatorSet == nil) {
        seperatorSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    }
    NSString *cleanPhoneNumber = [[string componentsSeparatedByCharactersInSet:seperatorSet] componentsJoinedByString:@""];
    if (hasPlusSign) {
        cleanPhoneNumber = [@"+" stringByAppendingString:cleanPhoneNumber];
    }
    
    NSError *error;
    static NSDataDetector *phoneDetector;
    if (phoneDetector == nil) {
        phoneDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    }
    NSTextCheckingResult *checkingResult = [phoneDetector firstMatchInString:cleanPhoneNumber options:0 range:NSMakeRange(0, cleanPhoneNumber.length)];
    if (error) {
        NSLog(@"phone error: %@", error);
    }
    NSLog(@"phoneNumber = %@", checkingResult.phoneNumber);
    return checkingResult.phoneNumber;
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
