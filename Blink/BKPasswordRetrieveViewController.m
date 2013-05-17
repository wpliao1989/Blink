//
//  BKPasswordRetrieveViewController.m
//  BlinkIPad
//
//  Created by Wei Ping on 13/2/6.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKPasswordRetrieveViewController.h"
#import "NSString+Additions.h"
#import "UIViewController+SharedString.h"
#import "BKAPIManager.h"
#import "UIViewController+SharedCustomizedUI.h"

@interface BKPasswordRetrieveViewController ()

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *email;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIImageView *titleBackground;
- (IBAction)sendPassWordButtonPressed:(id)sender;

@end

@implementation BKPasswordRetrieveViewController

- (void)setAccount:(NSString *)account {
    _account = [account copy];
    self.accountTextField.text = _account;
}

- (void)setEmail:(NSString *)email {
    _email = [email copy];
    self.emailTextField.text = _email;
}

#pragma mark - View controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.titleBackground setImage:[self titleImage]];
    [self initUI];
}

- (void)initUI {
    self.account = @"";
    self.email = @"";
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    if (textField == self.accountTextField) {
        self.account = [textField.text cleanString];
    }
    else if (textField == self.emailTextField) {
        self.email = [textField.text cleanString];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [self.emailTextField becomeFirstResponder];
        return NO;
    }
    else {
        return [super textFieldShouldReturn:textField];
    }
}

#pragma mark - Retrive password logic

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    [[BKAPIManager sharedBKAPIManager] forgetPasswordUserAccount:[self.account cleanString] email:[self.email cleanString] completionHandler:^(id data, NSError *error) {
        if (data) {
            successBlock(NSLocalizedString(@"Email sent!", @""));
        }
        else {
            failBlock(error);
        }
    }];
}

- (IBAction)sendPassWordButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    if ([self.account hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your account", @"")];
        return;
    }
    
    if ([self.email hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your email", @"")];
        return;
    }
    else if (![self.email isEmailFormat]) {
        [self showAlert:NSLocalizedString(@"Email format is incorrect", @"")];
        return;
    }
    
    [self showHUDViewWithMessage:NSLocalizedString(@"Processing...", @"")];
}
@end
