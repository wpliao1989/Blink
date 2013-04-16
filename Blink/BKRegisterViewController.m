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

@interface BKRegisterViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;
- (IBAction)confirmRegistrationButtonPressed:(id)sender;

@end

@implementation BKRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.titleBackground setImage:[[UIImage imageNamed:@"a1"] resizableImageWithCapInsets:UIEdgeInsetsMake(175, 158, 180, 158)]];
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
