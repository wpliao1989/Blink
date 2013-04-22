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
    [self.titleBackground setImage:[[UIImage imageNamed:@"a1"] resizableImageWithCapInsets:UIEdgeInsetsMake(175, 158, 180, 158)]];
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
//    [[BKAccountManager sharedBKAccountManager] loginWithAccount:@"Flyingman" password:@"fly123" CompleteHandler:^(BOOL success, NSError *error) {      
//        if (success) {
//            [self dismissViewControllerAnimated:YES completion:^{
//                
//            }];
//        }
//        else {
//            NSLog(@"login failed!");
//        }
//    }];
}
@end
