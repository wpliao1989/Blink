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

- (IBAction)confirmRegistrationButtonPressed:(id)sender;

@end

@implementation BKRegisterViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmRegistrationButtonPressed:(id)sender {
    [[BKAccountManager sharedBKAccountManager] loginWithAccount:@"Flyingman" password:@"fly123" CompleteHandler:^(BOOL success, NSError *error) {      
        if (success) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else {
            NSLog(@"login failed!");
        }
    }];
}
@end
