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

@interface BKLoginViewController ()

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registrationButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@end

@implementation BKLoginViewController


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

- (IBAction)loginButtonPressed:(id)sender {
    [[BKAccountManager sharedBKAccountManager] login];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)registrationButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"registrationSegue" sender:self];
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

- (void)dismissPresentedViewController:(UIViewController *)sender backToRootViewController:(BOOL)isGoingBack {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (isGoingBack) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

@end
