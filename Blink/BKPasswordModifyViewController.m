//
//  BKPasswordModifyViewController.m
//  Blink
//
//  Created by 維平 廖 on 13/4/15.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKPasswordModifyViewController.h"
#import "BKAccountManager.h"
#import "BKAPIError.h"
#import "UIViewController+SharedString.h"

@interface BKPasswordModifyViewController ()

@property (strong, nonatomic) NSString *userOldPWD;
@property (strong, nonatomic) NSString *userNewPWD;
@property (strong, nonatomic) NSString *userNewPWDConfirm;

@property (weak, nonatomic) IBOutlet UIView *viewForCalculatinContentSize;

@property (weak, nonatomic) IBOutlet UITextField *userOldPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNewPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNewPWDConfirmTextField;
- (IBAction)modifyPasswordButtonPressed:(id)sender;

@end

@implementation BKPasswordModifyViewController

@synthesize userOldPWD = _userOldPWD;
@synthesize userNewPWD = _userNewPWD;
@synthesize userNewPWDConfirm = _userNewPWDConfirm;

- (void)setUserOldPWD:(NSString *)userOldPWD {
    _userOldPWD = userOldPWD;
    self.userOldPWDTextField.text = userOldPWD;
}

- (void)setUserNewPWD:(NSString *)userNewPWD {
    _userNewPWD = userNewPWD;
    self.userNewPWDTextField.text = userNewPWD;
}

- (void)setUserNewPWDConfirm:(NSString *)userNewPWDConfirm {
    _userNewPWDConfirm = userNewPWDConfirm;
    self.userNewPWDConfirmTextField.text = userNewPWDConfirm;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.contentSize = self.viewForCalculatinContentSize.frame.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)initUI {
    self.userOldPWD = @"";
    self.userNewPWD = @"";
    self.userNewPWDConfirm = @"";
}

#pragma mark - Text field delegat

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userOldPWDTextField) {
        [self.userNewPWDTextField becomeFirstResponder];
        return NO;
    }
    else if (textField == self.userNewPWDTextField) {
        [self.userNewPWDConfirmTextField becomeFirstResponder];
        return NO;
    }
    else {
        return [super textFieldShouldReturn:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    if (textField == self.userOldPWDTextField) {
        self.userOldPWD = textField.text;
    }
    else if (textField == self.userNewPWDTextField) {
        self.userNewPWD = textField.text;
    }
    else if (textField == self.userNewPWDConfirmTextField) {
        self.userNewPWDConfirm = textField.text;
    }
    NSLog(@"oldPWD:%@, newPWD:%@, newPWDConfirm:%@", self.userOldPWD, self.userNewPWD, self.userNewPWDConfirm);
}

#pragma mark - Modify password logic

- (BOOL)isOldPWDandNewPWDValid {
    NSLog(@"Is password match:%@", [[BKAccountManager sharedBKAccountManager] isPasswordMatch:self.userOldPWD] ? @"YES": @"NO");
    
    return [[BKAccountManager sharedBKAccountManager] isPasswordMatch:self.userOldPWD] && ([self.userNewPWD isEqualToString:self.userNewPWDConfirm]);
}

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    [[BKAccountManager sharedBKAccountManager] editUserPWD:self.userNewPWD completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            successBlock(NSLocalizedString(@"Modification succeeded!", @"修改成功！"));
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            failBlock(error);
        }
    }];
}

- (IBAction)modifyPasswordButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    if (![self isOldPWDandNewPWDValid]) {
        [self showAlert:NSLocalizedString(@"Wrong password", @"")];
        return;
    }
    
    [self showHUDViewWithMessage:NSLocalizedString(@"Modidying...", @"修改中...")];
}

@end
