//
//  BKAccountActivationViewController.m
//  Blink
//
//  Created by 維平 廖 on 13/4/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAccountActivationViewController.h"
#import "UIViewController+SharedCustomizedUI.h"
#import "BKScrollableViewController+LoginFlow.h"
#import "BKAccountManager.h"
#import "BKAPIManager.h"
#import "UIViewController+BKBaseViewController.h"
#import "BKLoginViewController.h"

typedef NS_ENUM(NSUInteger, BKHUDViewType) {
    BKHUDViewTypeResendActivationLetter = 1,
    BKHUDViewTypeActivated = 2
};

@interface BKAccountActivationViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;
@property (nonatomic) BKHUDViewType HUDViewType;
- (IBAction)resendActivationButtonPressed:(id)sender;
- (IBAction)activatedButtonPressed:(id)sender;

@end

@implementation BKAccountActivationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[self viewBackgoundColor]];
    [self.titleBackground setImage:[self titleImage]];
    
    assert(self.userAccount);
    assert(self.userPassword);
}

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    if (self.HUDViewType == BKHUDViewTypeResendActivationLetter) {
        [[BKAPIManager sharedBKAPIManager] resendActivationLetterToAccount:self.userAccount password:self.userPassword completeHandler:^(id data, NSError *error) {
            if (data) {
                successBlock(@"發送成功！");
            }
            else {
                failBlock(error);
            }
        }];
    }
    else if (self.HUDViewType == BKHUDViewTypeActivated) {
        [self loginWithAccount:self.userAccount
                      password:self.userPassword
                  successBlock:successBlock
                     failBlock:failBlock
                  errorHandler:^(NSError *error) {}];
    }
}

- (BOOL)isTwoVCBackIsLoginVC {
    return [[self twoVCBack] isKindOfClass:[BKLoginViewController class]];
}

- (UIViewController *)twoVCBack {
    NSUInteger indexOfMe = [self.navigationController.viewControllers indexOfObject:self];
    if (indexOfMe >= 2) {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:indexOfMe - 2];
        return vc;
    }
    return nil;
}

- (IBAction)resendActivationButtonPressed:(id)sender {
    self.HUDViewType = BKHUDViewTypeResendActivationLetter;
    [self showHUDViewWithMessage:@"寄送認證信至信箱..."];
}

- (IBAction)activatedButtonPressed:(id)sender {
    self.HUDViewType = BKHUDViewTypeActivated;
    [self showHUDViewWithMessage:BKLoggingMessage];    
}

- (IBAction)backButtonPressed:(id)sender {
    
    if ([self isTwoVCBackIsLoginVC]) {
        [self.navigationController popToViewController:[self twoVCBack] animated:YES];
    }
    else {
        [super backButtonPressed:sender];
    }
}

@end
