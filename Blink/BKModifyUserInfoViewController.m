//
//  BKModifyUserInfoViewController.m
//  Blink
//
//  Created by 維平 廖 on 13/5/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKModifyUserInfoViewController.h"
#import "UIViewController+SharedCustomizedUI.h"
#import "NSString+Additions.h"
#import "UIViewController+SharedString.h"

@interface BKModifyUserInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *userAddressTextField;
@property (weak, nonatomic) IBOutlet UISwitch *savesInfoSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (strong, nonatomic) UIResponder *activeResponder;

- (IBAction)submitButtonPressed:(id)sender;

@end

@implementation BKModifyUserInfoViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.background setImage:[self resizableListImage]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.activeResponder resignFirstResponder];
}

#pragma mark - Keyboard events

- (void)keyBoardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"%@", NSStringFromCGRect(keyboardFrame));
    
    CGPoint oldOrigin = self.view.frame.origin;
    CGSize oldSize = self.view.frame.size;
    CGFloat padding = 5.0f;
    
    CGRect newFrame = CGRectMake(oldOrigin.x,
                                 keyboardFrame.origin.y - self.view.frame.size.height - padding,
                                 oldSize.width,
                                 oldSize.height);
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = newFrame;
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    //    NSDictionary *info = notification.userInfo;
    //    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"%@", NSStringFromCGRect(keyboardFrame));
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        self.userName = [textField.text cleanString];
    }
    else if (textField == self.userPhoneTextField) {
        self.userPhone = [textField.text cleanString];
    }
    else if (textField == self.userAddressTextField) {
        self.userAddress = [textField.text cleanString];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.userPhoneTextField becomeFirstResponder];
    }
    else if (textField == self.userPhoneTextField) {
        [self.userAddressTextField becomeFirstResponder];
    }
    else if (textField == self.userAddressTextField) {
        [self submitButtonPressed:nil];
    }
    
    return NO;
}

- (IBAction)submitButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    if ([self.userName hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your name", @"請輸入姓名")];
        return;
    }
    
    if ([self.userPhone hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your phone numeber", @"請輸入電話")];
        return;
    }
    
    if ([self.userAddress hasNoContent]) {
        [self showAlert:NSLocalizedString(@"Please enter your address", @"請輸入地址")];
        return;
    }
    
    [self.delegate modifyUserInfoVC:self didFinishedModificationSavingInfo:self.savesInfoSwitch.on];
}

@end
