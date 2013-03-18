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

@interface BKLoginViewController ()

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registrationButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;
@property (strong, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (strong, nonatomic) IBOutlet UISwitch *isSavingPreferencesSwitch;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *userAccount;
@property (strong, nonatomic) NSString *userPassword;

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) UITextField *activeField;

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
    self.isSavingPreferencesSwitch.on = [BKAccountManager sharedBKAccountManager].isSavingPreferences;
    if (self.isSavingPreferencesSwitch.on) {
        self.userAccount = [BKAccountManager sharedBKAccountManager].userPreferedAccount;
        self.userPassword = [BKAccountManager sharedBKAccountManager].userPreferedPassword;
    }
    
    [self.titleBackground setImage:[[UIImage imageNamed:@"a1"] resizableImageWithCapInsets:UIEdgeInsetsMake(175, 158, 180, 158)]];
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
//    self.isSavingPreferencesSwitch.onImage = [UIImage imageNamed:@"Default.png"];
//    self.isSavingPreferencesSwitch.offImage = [UIImage imageNamed:@"37x-Checkmark.png"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGSize sizeOfView = self.view.frame.size;
    self.scrollView.contentSize = sizeOfView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BKAccountManager sharedBKAccountManager].isSavingPreferences = self.isSavingPreferencesSwitch.on;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    [self.userAccountTextField resignFirstResponder];
    [self.userPasswordTextField resignFirstResponder];
    
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = BKLoggingMessage;
    [self.HUD show:YES];
    
    [[BKAccountManager sharedBKAccountManager] loginWithAccount:self.userAccount password:self.userPassword CompleteHandler:^(BOOL success, NSError *error) {
        if (success) {
            self.HUD.mode = MBProgressHUDModeText;
            self.HUD.labelText = BKLoginSuccessMessage;
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:YES completion:^{}];
                [self.HUD hide:YES];
            });            
            [[BKAccountManager sharedBKAccountManager] saveUserPreferedAccount:self.userAccount password:self.userPassword];
        }
        else {
            self.HUD.mode = MBProgressHUDModeText;
            if ([error.domain isEqualToString:BKErrorDomainWrongUserNameOrPassword]) {
                [[BKAccountManager sharedBKAccountManager] saveUserPreferedAccount:self.userAccount password:nil];
                self.HUD.labelText = @"帳號或密碼錯誤";
            }
            else {
                self.HUD.labelText = @"網路無回應";
            }                        
            [self.HUD hide:YES afterDelay:1.0];
        }        
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

- (IBAction)registrationButtonPressed:(id)sender {
//    [self performSegueWithIdentifier:@"registrationSegue" sender:self];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"registrationSegue"]) {
//        BKRegisterViewController *registerViewController = segue.destinationViewController;
//        registerViewController.delegate = self;
//    }    
}

//- (void)dismissPresentedViewController:(UIViewController *)sender backToRootViewController:(BOOL)isGoingBack {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    if (isGoingBack) {
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
//}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSLog(@"hudWasHidden");
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"begin editing!");
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.userAccountTextField) {
//        NSLog(@"account!");
        self.userAccount = textField.text;
    }
    else if (textField == self.userPasswordTextField) {
//        NSLog(@"password!");
        self.userPassword = textField.text;
    }
    self.activeField = nil;
}

- (void)keyBoardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    //    NSLog(@"view frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"aRect: %@", NSStringFromCGRect(aRect));
    //    NSLog(@"scroll view frame: %@", NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"avtiveField frame: %@", NSStringFromCGRect(self.activeField.frame));
    
    if (!CGRectContainsRect(aRect, self.activeField.frame)) {
        CGPoint scrollPoint = CGPointMake(0, self.activeField.frame.origin.y + self.activeField.frame.size.height - aRect.size.height);
        NSLog(@"Scroll point: %@", NSStringFromCGPoint(scrollPoint));
        //        [self.scrollView setContentOffset:scrollPoint animated:YES];
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    NSTimeInterval animationTime = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationTime animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];    
}

@end
