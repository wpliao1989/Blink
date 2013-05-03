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
@property (weak, nonatomic) IBOutlet UITextField *userPasswordConfirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *userAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;

@property (strong, nonatomic) NSString *userAccount;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *userPasswordConfirm;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;
@property (strong, nonatomic) NSString *userEmail;

@end

@implementation BKRegisterViewController

@synthesize userAccount = _userAccount;
@synthesize userPassword = _userPassword;
@synthesize userPasswordConfirm = _userPasswordConfirm;
@synthesize userName = _userName;
@synthesize userPhone = _userPhone;
@synthesize userAddress = _userAddress;
@synthesize userEmail = _userEmail;

- (void)setUserAccount:(NSString *)userAccount {
    _userAccount = [userAccount copy];
    self.userAccountTextField.text = _userAccount;
}

- (void)setUserPassword:(NSString *)userPassword {
    _userPassword = [userPassword copy];
    self.userPasswordTextField.text = _userPassword;
}

- (void)setUserPasswordConfirm:(NSString *)userPasswordConfirm {
    _userPasswordConfirm = [userPasswordConfirm copy];
    self.userPasswordConfirmTextField.text = _userPasswordConfirm;
}

- (void)setUserName:(NSString *)userName {
    _userName = [userName copy];
    self.userNameTextField.text = _userName;
}

- (void)setUserPhone:(NSString *)userPhone {
    _userPhone = [userPhone copy];
    self.userPhoneTextField.text = _userPhone;
}

- (void)setUserAddress:(NSString *)userAddress {
    _userAddress = [userAddress copy];
    self.userAddressTextField.text = _userAddress;
}

- (void)setUserEmail:(NSString *)userEmail {
    _userEmail = [userEmail copy];
    self.userEmailTextField.text = _userEmail;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.titleBackground setImage:[self titleImage]];
    [self initUI];    
}

- (void)initUI {
    self.userAccount = @"";
    self.userPassword = @"";
    self.userPasswordConfirm = @"";
    self.userEmail = @"";
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
        self.userAccount = [textField.text cleanString];
    }
    else if (textField == self.userPasswordTextField) {
        self.userPassword = textField.text;
    }
    else if (textField == self.userPasswordConfirmTextField) {
        self.userPasswordConfirm = textField.text;
    }
    else if (textField == self.userNameTextField) {
        self.userName = [textField.text cleanString];
    }
    else if (textField == self.userPhoneTextField) {
        self.userPhone = [textField.text cleanString];
    }
    else if (textField == self.userAddressTextField) {
        self.userAddress = [textField.text cleanString];
    }
    else if (textField == self.userEmailTextField) {
        self.userEmail = [textField.text cleanString];
    }
    
    NSLog(@"account:%@, pwd:%@, name:%@, phone:%@, address:%@, email:%@", self.userAccount, self.userPassword, self.userName, self.userPhone, self.userAddress, self.userEmail);
}

- (IBAction)confirmRegistrationButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    if ([self.userAccount hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your account", @"請填入帳號")];
        return;
    }
    
    if (self.userPassword == nil) {
        [self showAlert:NSLocalizedString(@"Please enter your password", @"請填入密碼")];
        return;
    }
    else if (![self.userPassword isEqualToString:self.userPasswordConfirm]) {
        [self showAlert:NSLocalizedString(@"Wrong password", @"")];
        return;
    }
    
    if ([self.userEmail hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your email", @"請填入email")];
        return;
    }
    else if (![self.userEmail isEmailFormat]) {
        [self showAlert:NSLocalizedString(@"Email format is incorrect", @"請輸入完整email格式")];
        return;
    }
    
    [self showHUDViewWithMessage:NSLocalizedString(@"Registering...", @"註冊中...")];
}

#pragma mark - HUD view

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    
    [[BKAPIManager sharedBKAPIManager] registerAccount:self.userAccount password:self.userPassword email:self.userEmail completeHandler:^(id data, NSError *error) {
        NSLog(@"Register account data:%@, error:%@", data, error);
        if (data) {
            successBlock(NSLocalizedString(@"Registration succeeded!", @"註冊成功!"));
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
