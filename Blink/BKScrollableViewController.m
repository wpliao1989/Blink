//
//  BKScrollableViewController.m
//  
//
//  Created by 維平 廖 on 13/3/29.
//
//

#import "BKScrollableViewController.h"

@implementation BKScrollableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customize scroll view
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSLog(@"%@", NSStringFromCGSize(self.view.frame.size));
//    NSLog(@"%@", NSStringFromCGSize(self.navigationController.view.frame.size));
    
    // Set content size of scroll view
    CGSize sizeOfView = self.view.frame.size;
    self.scrollView.contentSize = sizeOfView;
    
    // Register for input view event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    
    if (!CGRectContainsRect(aRect, self.activeResponder.frame)) {
//        CGPoint scrollPoint = CGPointMake(0, self.activeButton.frame.origin.y + self.activeButton.frame.size.height - aRect.size.height);
        //NSLog(@"Scroll point: %@", NSStringFromCGPoint(scrollPoint));
        //        [self.scrollView setContentOffset:scrollPoint animated:YES];
        [self.scrollView scrollRectToVisible:self.activeResponder.frame animated:YES];
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

@end
