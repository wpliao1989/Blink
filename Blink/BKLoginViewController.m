//
//  loginViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKLoginViewController.h"
#import "BKAccountManager.h"
#import "BKRegisterViewController.h"
#import "MBProgressHUD.h"
#import "BKAPIError.h"
#import "UIViewController+SharedCustomizedUI.h"
#import "BKScrollableViewController+LoginFlow.h"
#import "BKAccountActivationViewController.h"

@interface BKLoginViewController ()

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registrationButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;
@property (strong, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (strong, nonatomic) IBOutlet UISwitch *isSavingPreferencesSwitch;

@property (strong, nonatomic) NSString *userAccount;
@property (strong, nonatomic) NSString *userPassword;

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation BKLoginViewController

@synthesize userAccount = _userAccount;
@synthesize userPassword = _userPassword;

- (NSString *)userAccount {
    if (_userAccount == nil) {
        _userAccount = @"";
    }
    return _userAccount;
}

- (void)setUserAccount:(NSString *)userAccount {
    _userAccount = userAccount;
    self.userAccountTextField.text = userAccount;
}

- (NSString *)userPassword {
    if (_userPassword == nil) {
        _userPassword = @"";
    }
    return _userPassword;
}

- (void)setUserPassword:(NSString *)userPassword {
    _userPassword = userPassword;
    self.userPasswordTextField.text = userPassword;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.isSavingPreferencesSwitch.on = [BKAccountManager sharedBKAccountManager].isSavingPreferences;
    if (self.isSavingPreferencesSwitch.on) {
        self.userAccount = [BKAccountManager sharedBKAccountManager].userPreferedAccount;
        self.userPassword = [BKAccountManager sharedBKAccountManager].userPreferedPassword;
    }
    
    [self.titleBackground setImage:[self titleImage]];
//    self.isSavingPreferencesSwitch.onImage = [UIImage imageNamed:@"Default.png"];
//    self.isSavingPreferencesSwitch.offImage = [UIImage imageNamed:@"37x-Checkmark.png"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BKAccountManager sharedBKAccountManager].isSavingPreferences = self.isSavingPreferencesSwitch.on;
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginToActivationSegue"]) {
        BKAccountActivationViewController *aavc = segue.destinationViewController;
        aavc.userAccount = self.userAccount;
        aavc.userPassword = self.userPassword;
    }
}

#pragma mark - Custom login method

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    [self loginWithAccount:self.userAccount password:self.userPassword successBlock:successBlock failBlock:failBlock errorHandler:^(NSError *error) {
        if ([error.domain isEqualToString:BKErrorDomainWrongResult] &&
            (error.code == BKErrorWrongResultAccountNotActivated)) {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"loginToActivationSegue" sender:self];
            });
        }
    }];
//    [[BKAccountManager sharedBKAccountManager] loginWithAccount:self.userAccount password:self.userPassword CompleteHandler:^(BOOL success, NSError *error) {
//        if (success) {
//            [[BKAccountManager sharedBKAccountManager] saveUserPreferedAccount:self.userAccount password:self.userPassword];
//            double delayInSeconds = 1.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self dismissViewControllerAnimated:YES completion:^{}];
//            });
//            successBlock(BKLoginSuccessMessage);
//        }
//        else {
//            if ([error.domain isEqualToString:BKErrorDomainWrongResult] &&
//                (error.code == BKErrorWrongResultUserNameOrPassword)) {
//                [[BKAccountManager sharedBKAccountManager] saveUserPreferedAccount:self.userAccount password:nil];
//            }
//            else if ([error.domain isEqualToString:BKErrorDomainWrongResult] &&
//                     (error.code == BKErrorWrongResultAccountNotActivated)) {
//                double delayInSeconds = 1.0;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [self performSegueWithIdentifier:@"loginToActivationSegue" sender:self];
//                });
//            }
//            failBlock(error);
//        }
//    }];
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender {
    [self showHUDViewWithMessage:NSLocalizedString(@"Logging in...", @"登入中...")];
}

- (IBAction)registrationButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"registrationSegue" sender:self];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Text field

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    if (textField == self.userAccountTextField) {
        //        NSLog(@"account!");
        self.userAccount = textField.text;
    }
    else if (textField == self.userPasswordTextField) {
        //        NSLog(@"password!");
        self.userPassword = textField.text;
    }
}

@end
