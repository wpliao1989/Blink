//
//  BKOrderConfirmViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKOrderConfirmViewController.h"
#import "BKShopDetailViewController.h"
#import "BKOrderManager.h"

@interface BKOrderConfirmViewController ()

- (IBAction)orderConfirmButtonPressed:(id)sender;

@end

@implementation BKOrderConfirmViewController

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

- (IBAction)orderConfirmButtonPressed:(id)sender {
#warning Poping method should be changed to popToViewController
    [[BKOrderManager sharedBKOrderManager] sendOrder];
    
    UIViewController *destinationVC = [self.navigationController.viewControllers objectAtIndex:2];
    if ([destinationVC isKindOfClass:[BKShopDetailViewController class]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}
@end
