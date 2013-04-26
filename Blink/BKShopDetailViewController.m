//
//  BKShopDetailViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/1.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopDetailViewController.h"
#import "BKMainPageViewController.h"
#import "BKShopInfoForUser.h"
#import "BKShopInfoManager.h"
#import "BKMenuViewController.h"
#import "BKMakeOrderViewController.h"
#import "UIViewController+BKBaseViewController.h"
#import "BKOrderManager.h"
#import "BKAccountManager+Favorite.h"
#import "AppDelegate.h"
#import "NSString+QueryParser.h"

typedef NS_ENUM(NSUInteger, BKHUDViewType) {
    BKHUDViewTypeShopDetailDownload = 1,
    BKHUDViewTypeAddUserFavorite = 2
};

@interface BKShopDetailViewController ()

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)orderDeliverButtonPressed:(id)sender;
- (IBAction)takeAwayButtonPressed:(id)sender;
- (IBAction)addFavoriteShopButtonPressed:(id)sender;

@property (nonatomic, strong) BKShopInfoForUser *shopInfo;
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

@property (nonatomic) BKHUDViewType hudviewType;

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

- (BKShopInfoForUser *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
}

#pragma mark - View controller life cycle

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
    
    [[BKShopInfoManager sharedBKShopInfoManager] loadShopDetailDataShopID:self.shopID
                                                          completeHandler:^(BOOL success) {
        if (success) {
            self.scrollView.userInteractionEnabled = YES;
            [self initShop];
            [self configureIntroSection];
            [self configureBottomSection];
            [self configureScrollView];
        }
        else {
            self.hudviewType = BKHUDViewTypeShopDetailDownload;
            [self showHUDViewWithMessage:@""];
        }
    }];        
}

- (BOOL)isUsingOwnScrollview {
    return YES;
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
        //self.shopPic.layer.cornerRadius = 8.0f;
        //[self.shopPic.layer setMasksToBounds:YES];
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

#pragma mark - HUD view

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    
    if (self.hudviewType == BKHUDViewTypeShopDetailDownload) {
        failBlock([NSError errorWithDomain:BKErrorDomainNetwork code:BKErrorWrongResultGeneral userInfo:@{NSLocalizedDescriptionKey:@"伺服器錯誤"}]);
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    else if (self.hudviewType == BKHUDViewTypeAddUserFavorite) {
        if ([BKAccountManager sharedBKAccountManager].isLogin == NO) {
            failBlock([NSError errorWithDomain:BKErrorDomainNetwork code:BKErrorDomainWrongResult userInfo:@{NSLocalizedDescriptionKey:@"請先登入"}]);
        }
        else {
            [[BKAccountManager sharedBKAccountManager] addUserFavoriteShopID:self.shopID completeHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Add user favorite success! shopID:%@", self.shopID);
                    successBlock(@"新增成功!");
                }
                else {
                    NSLog(@"Add user favorite failed! shopID:%@", self.shopID);
                    failBlock([NSError errorWithDomain:BKErrorDomainNetwork code:BKErrorDomainWrongResult userInfo:@{NSLocalizedDescriptionKey:@"新增失敗..."}]);
                }
            }];
        }        
    }
    else {
        failBlock(nil);
    }
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

- (IBAction)addFavoriteShopButtonPressed:(id)sender {
    self.hudviewType = BKHUDViewTypeAddUserFavorite;
    [self showHUDViewWithMessage:@"新增中..."];
}
- (void)viewDidUnload {
    [self setShopURL:nil];
    [self setUrlAndIntroSeperator:nil];
    [self setShopMinDeliveryLabel:nil];
    [self setShopPic:nil];
    [super viewDidUnload];
}
@end

#import "UIViewController+SharedString.h"

NSString *const kBKFacebookPublishPermission = @"publish_actions";
NSString *const kBKFacebookShareDialogPostID = @"postId";
NSString *const kBKFacebookFeedDialogPostID = @"post_id";
NSString *const kBKFacebookPostSucceed = @"分享成功！";

@interface BKShopDetailViewController (Facebook)

- (IBAction)facebookButtonPressed:(UIButton *)sender;

- (NSArray *)permissions;
- (FBShareDialogParams *)dialogParams;
- (NSString *)initialText;

- (NSDictionary *)parameterForFeedDialogFromParams:(FBShareDialogParams *)params;

// Publish methods
- (BOOL)publishWithOSIntegratedShareDialog;
- (void)publishWithWebDialog;

//- (void)choosePostMethod;
//- (void)publishStory;

@end

@implementation BKShopDetailViewController (Facebook)

- (NSString *)checkPostId:(NSDictionary *)results {
    NSString *message = @"Posted successfully.";
    // Share dialog
    NSString *postId = results[kBKFacebookShareDialogPostID];
    if (!postId) {
        // Feed dialog
        postId = results[kBKFacebookFeedDialogPostID];
    }
    if (postId) {
        message = [NSString stringWithFormat:@"Posted story, id: %@", postId];
    }
    return message;
}

- (NSString *)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    if (error.fberrorShouldNotifyUser ||
        error.fberrorCategory == FBErrorCategoryPermissions ||
        error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        errorMessage = error.fberrorUserMessage;
    } else {
        errorMessage = @"網路發生錯誤，請稍候再試";
    }
    return errorMessage;
}

- (NSArray *)permissions {
    return @[kBKFacebookPublishPermission];
}

- (FBShareDialogParams *)dialogParams {
    FBShareDialogParams *result = [[FBShareDialogParams alloc] init];
    result.name = @"Link name";
    result.caption = @"Link caption";
    result.description = @"Link description";
    result.link = [NSURL URLWithString:self.shopInfo.shopURL];
    result.picture = [NSURL URLWithString:@"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png"];
    
    return result;
}

- (NSString *)initialText {
    return @"";
}

- (NSDictionary *)parameterForFeedDialogFromParams:(FBShareDialogParams *)params {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (params.name) {
        [result setObject:params.name forKey:@"name"];
    }
    
    if (params.caption) {
        [result setObject:params.caption forKey:@"caption"];
    }
    
    if (params.description) {
        [result setObject:params.description forKey:@"description"];
    }
    
    if (params.link) {
        [result setObject:[params.link absoluteString] forKey:@"link"];
    }
    
    if (params.picture) {
        [result setObject:[params.picture absoluteString] forKey:@"picture"];
    }
    
    return [NSDictionary dictionaryWithDictionary:result];
}

- (BOOL)publishWithOSIntegratedShareDialog {
    NSLog(@"self.shopInfo.image = %@", self.shopInfo.pictureImage);
    return [FBDialogs
            presentOSIntegratedShareDialogModallyFrom:self
            initialText:[self initialText]
            image:nil
            url:[NSURL URLWithString:@"http://www.google.com"]
            handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                // Only show the error if it is not due to the dialog
                // not being supported, i.e. code = 7, otherwise ignore
                // because our fallback will show the share view controller.
                if (error && [error code] == 7) {
                    return;
                }
                if (error) {
                    [self showAlert:[self checkErrorMessage:error]];
                } else if (result == FBNativeDialogResultSucceeded) {
                    [self showAlert:kBKFacebookPostSucceed];
                }
            }];
}

- (void)publishWithWebDialog {
    
    // Put together the dialog parameters
    NSDictionary *params = [self parameterForFeedDialogFromParams:[self dialogParams]];
    NSLog(@"params:%@", params);
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:[FBSession activeSession]
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             [self showAlert:[self checkErrorMessage:error]];
         }
         else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             }
             else {
                 // Handle the publish feed callback
                 NSLog(@"resultURL:%@, query:%@", resultURL, [resultURL query]);
                 NSDictionary *urlParams = [[resultURL query] queryDictionary];
                 NSLog(@"urlParams:%@", urlParams);
                 if (![urlParams valueForKey:kBKFacebookFeedDialogPostID]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     //[self showAlert:[self checkPostId:urlParams]];
                     [self showAlert:kBKFacebookPostSucceed];
                 }
             }
         }
     }];
}

- (IBAction)facebookButtonPressed:(UIButton *)sender {
    [self publishWithWebDialog];
    return;
    
    // First attempt: Publish using the iOS6 OS Share dialog
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    if (canShareiOS6) {
        [self publishWithOSIntegratedShareDialog];
    }
    
    // Second fallback: Publish using the feed dialog
    if (!canShareiOS6) {
        [self publishWithWebDialog];
    }
    
    return;
    
//    if (appDelegate.session == nil) {
//        appDelegate.session = [[FBSession alloc] init];
//    }
//    
//    NSLog(@"session:%@", appDelegate.session);
//    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
//    p.link = [NSURL URLWithString:@"http://www.google.com"];
//    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
//    //BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
//    NSLog(@"canShareFB:%@", canShareFB ? @"YES" : @"NO");
//    NSLog(@"canShareiOS6:%@", canShareiOS6 ? @"YES" : @"NO");
//    if (!appDelegate.session.isOpen) {
//        
//        if (appDelegate.session.state != FBSessionStateCreated) {
//            // Create a new, logged out session.
//            appDelegate.session = [[FBSession alloc] init];
//        }        
//        
//        [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//            
//            //NSLog(@"session:%@, status:%u, error:%@", session, status, error);
//            if (session.isOpen) {
//                //[FBSession setActiveSession:session];
//                NSLog(@"Open success!");
//                NSLog(@"canShareFB:%@", canShareFB ? @"YES" : @"NO");
//                NSLog(@"canShareiOS6:%@", canShareiOS6 ? @"YES" : @"NO");
//                [self choosePostMethod];
//            }
//            else if (error != nil) {
//                NSLog(@"Error:%@", error);
//            }
//            else {
//                appDelegate.session = nil;
//                NSLog(@"Close success!");
//            }
//        }];
//    }
//    else {
//        [self choosePostMethod];
//    }
}

//- (void) performPublishAction:(void (^)(void)) action {
//    
//    // we defer request for permission to post to the moment of post, then we check for the permission
//    if ([FBSession.activeSession.permissions indexOfObject:kBKFacebookPublishPermission] == NSNotFound) {
//        // if we don't already have the permission, then we request it now
//        [FBSession.activeSession requestNewPublishPermissions:[self permissions]
//                                              defaultAudience:FBSessionDefaultAudienceFriends
//                                            completionHandler:^(FBSession *session, NSError *error) {
//                                                if (!error) {
//                                                    action();
//                                                }
//                                                //For this example, ignore errors (such as if user cancels).
//                                            }];
//    } else {
//        action();
//    }
//    
//}

//- (void)choosePostMethod {
//    
//    // First attempt: Publish using the iOS6 OS Share dialog
//    BOOL displayedNativeDialog = [self publishWithOSIntegratedShareDialog];
//    return;
//    if (!displayedNativeDialog) {
//        // Next try to post using Facebook's iOS6 integration
//        
//        
//        if (!displayedNativeDialog) {
//            // Lastly, fall back on a request for permissions and a direct post using the Graph API
//            [self performPublishAction:^{
//                NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", @"User", [NSDate date]];
//                [self publishStory];
//            }];
//        }
//    }
//}
//
//- (void)publishStory
//{
//    NSMutableDictionary *postParams =  [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//     @"https://developers.facebook.com/ios", @"link",
//     @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
//     @"Facebook SDK for iOS", @"name",
//     @"Build great social apps and get more installs.", @"caption",
//     @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
//     nil];
//    [FBRequestConnection
//     startWithGraphPath:@"me/feed"
//     parameters:postParams
//     HTTPMethod:@"POST"
//     completionHandler:^(FBRequestConnection *connection,
//                         id result,
//                         NSError *error) {
//         NSString *alertText;
//         if (error) {
//             alertText = [NSString stringWithFormat:
//                          @"error: domain = %@, code = %d, %@",
//                          error.domain, error.code, error.localizedDescription];
//         } else {
//             alertText = [NSString stringWithFormat:
//                          @"Posted action, id: %@",
//                          [result objectForKey:@"id"]];
//         }
//         // Show the result in an alert
//         [[[UIAlertView alloc] initWithTitle:@"Result"
//                                     message:alertText
//                                    delegate:self
//                           cancelButtonTitle:@"OK!"
//                           otherButtonTitles:nil]
//          show];
//     }];
//}

@end

#import "GPPShare.h"

@interface BKShopDetailViewController (GooglePlus)

- (IBAction)googlePlusButtonPressed:(UIButton *)sender;


@end

@implementation BKShopDetailViewController (GooglePlus)

- (IBAction)googlePlusButtonPressed:(UIButton *)sender {

    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    [shareBuilder setContentDeepLinkID:@"com.flyingman.Blink"];
    // This line will fill out the title, description, and thumbnail of the item
    // you're sharing based on the URL you included.
    [shareBuilder setURLToShare:[self dialogParams].link];
    
    //[shareBuilder setTitle:@"Hello" description:@"123" thumbnailURL:nil];
    
    [shareBuilder setPrefillText:[self initialText]];
    
    [shareBuilder open];
    
}
@end
