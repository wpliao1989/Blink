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
#import "BKOrderManager.h"

@interface BKShopDetailViewController ()

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)orderDeliverButtonPressed:(id)sender;
- (IBAction)takeAwayButtonPressed:(id)sender;

@property (nonatomic, strong) BKShopInfo *shopInfo;
@property (strong, nonatomic) UIImage *shopImage; // Keep a strong pointer to prevent image from dealloc

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *topSectionBackground;
@property (strong, nonatomic) IBOutlet UIImageView *introduceSectionBackground;
@property (strong, nonatomic) IBOutlet UIImageView *urlAndIntroSeperator;
@property (strong, nonatomic) IBOutlet UIImageView *shopPic;
@property (strong, nonatomic) IBOutlet UIView *introSection;
@property (strong, nonatomic) IBOutlet UIView *bottomSection;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopCommerceTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopOpenTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopMinDeliveryLabel;
@property (strong, nonatomic) IBOutlet UITextView *shopURL;
@property (strong, nonatomic) IBOutlet UITextView *shopIntro;

- (BOOL)callPhoneNumberWithPhoneString:(NSString *)phoneNumber;
- (NSString *)phoneNumberExtractedFromString:(NSString *)string;

- (NSString *)stringForMinDeliveryCostLabelWithCost:(NSNumber *)cost;
- (NSString *)currencyStringForPrice:(NSNumber *)price;

- (void)initShop;
- (void)configureShopImage;
- (void)configureIntroSection;
- (void)configureBottomSection;
- (void)configureScrollView;

@end

@implementation BKShopDetailViewController

@synthesize shopInfo = _shopInfo;

- (BKShopInfo *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
}

#pragma mark - View controller life cycle

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopImageDidDownload:) name:BKShopImageDidDownloadNotification object:nil];
    self.navigationItem.title = self.shopInfo.name;
    [self.topSectionBackground setImage:[[UIImage imageNamed:@"list_try"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 14, 67, 20)]];
    
    self.scrollView.userInteractionEnabled = NO;
    [self initShop];
    [self configureIntroSection];
    [self configureBottomSection];
    [self configureScrollView];
    
    [[BKShopInfoManager sharedBKShopInfoManager] loadShopDetailDataShopID:self.shopID completeHandler:^(BOOL success) {
        self.scrollView.userInteractionEnabled = YES;
        [self initShop];
        [self configureIntroSection];
        [self configureBottomSection];
        [self configureScrollView];        
    }];        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];   
    NSLog(self.isMovingToParentViewController?@"is being push":@"not being push");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];    
    
    NSLog(self.isMovingFromParentViewController? @"is beging pop":@"not being pop");
    if (self.isMovingToParentViewController) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"menuSegue"]) {
        BKMenuViewController *menuVC = segue.destinationViewController;
//        menuVC.navigationItem.title = [self.shopInfo.name stringByAppendingString:@"的菜單"];
        menuVC.navigationItem.title = @"菜單";
        menuVC.menu = self.shopInfo.menu;
    }
    else if ([segue.identifier isEqualToString:@"makeOrderSegue"]) {
        BKMakeOrderViewController *makeOrderVC = segue.destinationViewController;
//        makeOrderVC.menu = self.shopInfo.menu;
//        makeOrderVC.shopInfo = self.shopInfo;
        makeOrderVC.shopID = self.shopID;
    }
}

#pragma mark - UI Initialization

- (void)initShop {
    [self configureShopImage];
    
    self.shopNameLabel.text = self.shopInfo.name;
    self.shopCommerceTypeLabel.text = [self.shopInfo localizedTypeString];
    self.shopAddressLabel.text = self.shopInfo.address;
    self.shopPhoneLabel.text = self.shopInfo.phone;
    self.shopOpenTimeLabel.text = self.shopInfo.businessHours;
    self.shopIntro.text = self.shopInfo.shopDescription;
    self.shopURL.text = self.shopInfo.shopURL;
    self.shopMinDeliveryLabel.text = [self stringForMinDeliveryCostLabelWithCost:self.shopInfo.minPrice];
}

- (void)configureShopImage {
    //    self.shopPic.image = self.shopInfo.pictureImage;
    //    NSLog(@"shop image size = %@", NSStringFromCGSize(self.shopInfo.pictureImage.size));
    if (self.shopInfo.pictureImage != nil) {
        [self.shopPic setImage:self.shopInfo.pictureImage];
        self.shopImage = self.shopInfo.pictureImage;
        //    [self.shopPic.layer setBorderColor:[UIColor whiteColor].CGColor];
        //    [self.shopPic.layer setBorderWidth:3];
    }
    else {        
        NSLog([[BKShopInfoManager sharedBKShopInfoManager] isDownloadingImageForShopInfo:self.shopInfo]?@"Yes downloading %@":@"NO not downloading %@", self.shopInfo.name);
    }
}

- (void)shopImageDidDownload:(NSNotification *)notification {    
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:kBKShopImageDidDownloadUserInfoShopInfo] == self.shopInfo) {
        NSLog(@"Shop detail: image did download! %@", self.shopInfo.name);
        [self configureShopImage];
    }
}

- (void)configureIntroSection {
    // Set background image
    UIImage *backgroundImage = [[UIImage imageNamed:@"introduce"] resizableImageWithCapInsets:UIEdgeInsetsMake(70, 60, 70, 60)];
    [self.introduceSectionBackground setImage:backgroundImage];
    CGFloat backgoundImageHeight = backgroundImage.size.height;
    
    // Configure URL frame
    CGRect URLNewFrame = self.shopURL.frame;
    URLNewFrame.size.height = self.shopURL.contentSize.height;
    self.shopURL.frame = URLNewFrame;
    
    // Configure seperator
    CGFloat URLAndIntroDistance = 5.0;
    CGRect seperatorNewFrame = self.urlAndIntroSeperator.frame;
    CGPoint seperatorNewOrigin = seperatorNewFrame.origin;
    seperatorNewOrigin.y = URLNewFrame.origin.y + URLNewFrame.size.height + URLAndIntroDistance/2;
    seperatorNewFrame.origin = seperatorNewOrigin;
    self.urlAndIntroSeperator.frame = seperatorNewFrame;
    
    // Configure intro frame
    CGPoint newOrigin = CGPointMake(URLNewFrame.origin.x, URLNewFrame.origin.y + URLNewFrame.size.height + URLAndIntroDistance);
    CGRect introNewFrame = self.shopIntro.frame;
    introNewFrame.origin = newOrigin;
    introNewFrame.size.height = self.shopIntro.contentSize.height;
    self.shopIntro.frame = introNewFrame;
    
    // Configure section frame
    CGFloat shopIntroBottomPoint =  self.shopIntro.frame.origin.y + self.shopIntro.contentSize.height;
    CGFloat sectionHeight = shopIntroBottomPoint + 20.0;
    if (sectionHeight < backgoundImageHeight) {
        sectionHeight = backgoundImageHeight;
    }
    CGRect introSectionNewFrame = self.introSection.frame;
    introSectionNewFrame.size.height = sectionHeight;
    NSLog(@"old frame = %@", NSStringFromCGRect(self.introSection.frame));
    self.introSection.frame = introSectionNewFrame;
    NSLog(@"new frame = %@", NSStringFromCGRect(self.introSection.frame));
    NSLog(@"URL text view frame: %@", NSStringFromCGRect(self.shopURL.frame));
    NSLog(@"intro text view frame: %@", NSStringFromCGRect(self.shopIntro.frame));
    NSLog(@"height of text: %f", self.shopIntro.contentSize.height);
}

- (void)configureBottomSection {
    CGFloat introSectionAndBottomSectionDistance= 10.0;
    CGRect newFrame = self.bottomSection.frame;
    newFrame.origin.y = self.introSection.frame.origin.y + self.introSection.frame.size.height + introSectionAndBottomSectionDistance;
    self.bottomSection.frame = newFrame;
}

- (void)configureScrollView {
    CGFloat contentHeight = self.bottomSection.frame.origin.y + self.bottomSection.frame.size.height;
    [self.scrollView setContentSize:CGSizeMake(320, contentHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]];
}

#pragma mark - Price string

- (NSString *)stringForMinDeliveryCostLabelWithCost:(NSNumber *)cost {
    return [NSString stringWithFormat:@"最低外送價：%@", [self currencyStringForPrice:cost]];
}

#pragma mark - Currency formatter

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

#pragma mark - Phone number detecting and calling

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

#pragma mark - IBActions

- (IBAction)menuButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"menuSegue" sender:self];
}

- (IBAction)orderDeliverButtonPressed:(id)sender {
    [[BKOrderManager sharedBKOrderManager] setOrderMethod:BKOrderMethodDelivery];
    [self performSegueWithIdentifier:@"makeOrderSegue" sender:self];
}

- (IBAction)takeAwayButtonPressed:(id)sender {
    [[BKOrderManager sharedBKOrderManager] setOrderMethod:BKOrderMethodTakeout];
    [self performSegueWithIdentifier:@"makeOrderSegue" sender:self];
}
- (void)viewDidUnload {
    [self setShopURL:nil];
    [self setUrlAndIntroSeperator:nil];
    [self setShopMinDeliveryLabel:nil];
    [self setShopPic:nil];
    [super viewDidUnload];
}
@end
