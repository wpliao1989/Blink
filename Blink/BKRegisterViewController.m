//
//  BKRegisterViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKRegisterViewController.h"
#import "BKAccountManager.h"
#import "UIViewController+BKBaseViewController.h"
#import "NSString+Numeric.h"
#import "UIViewController+SharedCustomizedUI.h"
#import "BKAPIManager.h"
#import "UIViewController+SharedString.h"
#import "BKAccountActivationViewController.h"
#import "NSString+Additions.h"

@interface BKRegisterViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;
- (IBAction)confirmRegistrationButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *userAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;

@property (strong, nonatomic) NSString *userAccount;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;
@property (strong, nonatomic) NSString *userEmail;

@end

@implementation BKRegisterViewController

@synthesize userAccount = _userAccount;
@synthesize userPassword = _userPassword;
@synthesize userName = _userName;
@synthesize userPhone = _userPhone;
@synthesize userAddress = _userAddress;
@synthesize userEmail = _userEmail;

- (void)setUserAccount:(NSString *)userAccount {
    _userAccount = userAccount;
    self.userAccountTextField.text = userAccount;
}

- (void)setUserPassword:(NSString *)userPassword {
    _userPassword = userPassword;
    self.userPasswordTextField.text = userPassword;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.userNameTextField.text = userName;
}

- (void)setUserPhone:(NSString *)userPhone {
    _userPhone = userPhone;
    self.userPhoneTextField.text = userPhone;
}

- (void)setUserAddress:(NSString *)userAddress {
    _userAddress = userAddress;
    self.userAddressTextField.text = userAddress;
}

- (void)setUserEmail:(NSString *)userEmail {
    _userEmail = userEmail;
    self.userEmailTextField.text = userEmail;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.titleBackground setImage:[self titleImage]];
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"registerToActivationSegue"]) {
        BKAccountActivationViewController *aavc = segue.destinationViewController;
        aavc.userAccount = self.userAccount;
        aavc.userPassword = self.userPassword;
    }
}

#pragma mark - Text field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.userPhoneTextField) {
        NSLog(@"text change in range: %@, with string: %@", NSStringFromRange(range), string);
        NSLog(@"current string length: %d", textField.text.length);
        
        if ([string isAllDigits]) {
            return YES;
        }
        else if ([string isEqualToString:@" "] && range.length > 0) {
            // The character is space, but the action is deleting, thus return YES
            return YES;
        }
        else {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    if (textField == self.userAccountTextField) {
        self.userAccount = textField.text;
    }
    else if (textField == self.userPasswordTextField) {
        self.userPassword = textField.text;
    }
    else if (textField == self.userNameTextField) {
        self.userName = textField.text;
    }
    else if (textField == self.userPhoneTextField) {
        self.userPhone = textField.text;
    }
    else if (textField == self.userAddressTextField) {
        self.userAddress = textField.text;
    }
    else if (textField == self.userEmailTextField) {
        self.userEmail = textField.text;
    }
    
    NSLog(@"account:%@, pwd:%@, name:%@, phone:%@, address:%@, email:%@", self.userAccount, self.userPassword, self.userName, self.userPhone, self.userAddress, self.userEmail);
}

- (IBAction)confirmRegistrationButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    if ([self.userAccount hasNoContent]) {
        [self showAlert:@"請填入帳號"];
        return;
    }
    
    if (self.userPassword == nil) {
        [self showAlert:@"請填入密碼"];
        return;
    }
    
    if ([self.userEmail hasNoContent]) {
        [self showAlert:@"請填入email"];
        return;
    }
    
    [self showHUDViewWithMessage:@"註冊中..."];
}

#pragma mark - HUD view

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    
    [[BKAPIManager sharedBKAPIManager] registerAccount:self.userAccount password:self.userPassword email:self.userEmail completeHandler:^(id data, NSError *error) {
        NSLog(@"Register account data:%@, error:%@", data, error);
        if (data) {
            successBlock(@"註冊成功!");
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"registerToActivationSegue" sender:self];
            });            
        }
        else {
            failBlock(error);
        }
    }];
}

@end
