//
//  BKBaseViewController.m
//  Blink
//
//  Created by Wei Ping on 13/3/12.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "UIViewController+BKBaseViewController.h"
//#import "BKMainPageViewController.h"
//#import "BKCustomUIViewController.h"
//#import "BKCustomUIManager.h"

@implementation UIViewController(CustomButtons)

//- (void)addBackButton {
//    NSLog(@"add back button");
//    if (self.navigationController.viewControllers.count > 1) {
//        UIBarButtonItem *backButton = [BKCustomUIManager sharedBKCustomUIManager].backButton;
//        UIButton *trueBackButton = (UIButton *)[backButton.customView viewWithTag:0];
//        [trueBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = backButton;
//    }
//}
//
//- (void)addHomeButton {
//    NSLog(@"add home button");
////    self.navigationItem.rightBarButtonItem = self.homeButton;    
//}

- (IBAction)backButtonPressed:(id)sender {
    NSLog(@"back button pressed!");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)homeButtonPressed:(id)sender {
    NSLog(@"home button pressed!");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

@implementation UIViewController (AdditionalSetup)

- (void)viewDidLoad {
    NSLog(@"add subview! self class %@", [self class]);
    if (![self isKindOfClass:[UINavigationController class]]) {
//        NSLog(@"self.view.frame = %@", NSStringFromCGRect(self.view.frame));
        CGRect bounds = self.view.bounds;
        CGFloat viewWidth = bounds.size.width;
        CGFloat viewHeight = bounds.size.height;
        
        UIImageView *demoView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/2 - 113, viewHeight/2 - 64, 226, 128)];
        demoView.image = [UIImage imageNamed:@"demo"];
        demoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        [self.view addSubview:demoView];
        NSLog(@"self.subviews = %@", self.view.subviews);
    }    
}

@end




