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
    if (![self isUsingOwnScrollview]) {
        [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
    }    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)isUsingOwnScrollview {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSLog(@"%@", NSStringFromCGSize(self.view.frame.size));
//    NSLog(@"%@", NSStringFromCGSize(self.navigationController.view.frame.size));
    
    // Set content size of scroll view
    if (![self isUsingOwnScrollview]) {
        CGSize sizeOfView = self.scrollView.frame.size;
        self.scrollView.contentSize = sizeOfView;
    }
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
    if (self.scrollView == nil) {
        return;
    }
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect scrollViewFrameInWindowCoordinate = [self.scrollView convertRect:self.scrollView.frame toView:nil];
    CGFloat scrollViewBottomY = CGRectGetMaxY(scrollViewFrameInWindowCoordinate);
    CGFloat windowBottomY = CGRectGetMaxY(self.view.window.frame);
    CGFloat bottomPaddling = windowBottomY - scrollViewBottomY;
    
    if (windowBottomY <= 0) {
        return;
    }
    
    NSLog(@"keyboard will show = %@", notification.userInfo);
    //NSLog(@"window:%@", self.view.window);
    //NSLog(@"11111 %f", scrollViewBottomY);
    //NSLog(@"22222 %f", windowBottomY);
    //NSLog(@"Bottom paddling %f", bottomPaddling);
    //NSLog(@"!!!!!!!!! rect = %@", NSStringFromCGRect(scrollViewFrameInWindowCoordinate));
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - bottomPaddling, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
    
    CGRect aRect = self.scrollView.frame;
    aRect.size.height -= self.scrollView.contentInset.bottom;
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
            
            NSLog(@"self.scrollView.contentInset:%@", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
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
    if (self.scrollView == nil) {
        return;
    }
    NSDictionary* info = [notification userInfo];
    NSLog(@"keyboard will hide = %@", notification.userInfo);
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

#pragma mark - HUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    //NSLog(@"hudWasHidden");
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

@end
