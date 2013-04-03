//
//  BKScrollableViewController.m
//  
//
//  Created by 維平 廖 on 13/3/29.
//
//

#import "BKScrollableViewController.h"
#import "MBProgressHUD.h"
#import "BKAccountManager.h"

@interface BKScrollableViewController()

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation BKScrollableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customize scroll view
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSLog(@"%@", NSStringFromCGSize(self.view.frame.size));
//    NSLog(@"%@", NSStringFromCGSize(self.navigationController.view.frame.size));
    
    // Set content size of scroll view
    CGSize sizeOfView = self.view.frame.size;
    self.scrollView.contentSize = sizeOfView;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
}

#pragma mark - Keyboard event

- (void)keyBoardWillShow:(NSNotification *)notification {
    //NSLog(@"keyBoardDidShow");
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
    //NSLog(@"aRect: %@", NSStringFromCGRect(aRect));
    //    NSLog(@"scroll view frame: %@", NSStringFromCGRect(self.scrollView.frame));
    //NSLog(@"avtiveField frame: %@", NSStringFromCGRect(self.activeField.frame));
    if (self.activeResponder != nil) {
        if (!CGRectContainsRect(aRect, self.activeResponder.frame)) {
            //        CGPoint scrollPoint = CGPointMake(0, self.activeButton.frame.origin.y + self.activeButton.frame.size.height - aRect.size.height);
            //NSLog(@"Scroll point: %@", NSStringFromCGPoint(scrollPoint));
            //        [self.scrollView setContentOffset:scrollPoint animated:YES];
            [self.scrollView scrollRectToVisible:self.activeResponder.frame animated:YES];
        }
    }    

    //    if (!CGRectContainsRect(aRect, self.activeField.frame)) {
    //        CGPoint scrollPoint = CGPointMake(0, self.activeField.frame.origin.y + self.activeField.frame.size.height - aRect.size.height);
    //        NSLog(@"Scroll point: %@", NSStringFromCGPoint(scrollPoint));
    //        //        [self.scrollView setContentOffset:scrollPoint animated:YES];
    //        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    //    }
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    //NSLog(@"keyBoardWillHide");
    NSDictionary* info = [notification userInfo];
    NSTimeInterval animationTime = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationTime animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeResponder = nil;
}

@end

#import "BKAPIError.h"

@implementation BKScrollableViewController (HUDview)

- (void)showHUDViewWithMessage:(NSString *)message {
    [self.activeResponder resignFirstResponder];
    
    //    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.delegate = self;
    self.HUD.labelText = message;
    [self.HUD show:YES];
    
    [self dismissHUDSuccessBlock:^(NSString *successMessage) {
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.labelText = successMessage;
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){            
            [self.HUD hide:YES];
        });
    } failBlock:^(NSError *error) {
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.labelText = error.userInfo[kBKErrorMessage];
//        if ([error.domain isEqualToString:BKErrorDomainWrongUserNameOrPassword]) {
//            self.HUD.labelText = @"帳號或密碼錯誤";
//        }
//        else {
//            self.HUD.labelText = @"網路無回應";
//        }
        [self.HUD hide:YES afterDelay:1.0];
    }];
}

- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock {
    // Do success block by default
    successBlock(@"");
}

@end
