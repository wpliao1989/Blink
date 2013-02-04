//
//  BKShopDetailViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/1.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKShopDetailViewController.h"

@interface BKShopDetailViewController ()

- (IBAction)menuButtonPressed:(id)sender;

@end

@implementation BKShopDetailViewController

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

- (IBAction)menuButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"menuSegue" sender:self];
}
@end
