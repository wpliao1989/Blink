//
//  mainPageViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMainPageViewController.h"
#import "BKAccountManager.h"

@interface BKMainPageViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *userToolButton;

- (IBAction)searchShopButtonPressed:(id)sender;
- (IBAction)searchFoodButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)userToolButtonPressed:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;

@end

@implementation BKMainPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {    
    if ([BKAccountManager sharedBKAccountManager].isLogin == YES) {        
        self.navigationItem.rightBarButtonItem = self.userToolButton;
    }
    else {        
        self.navigationItem.rightBarButtonItem = self.loginButton;
    }
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

- (IBAction)searchShopButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"shopListSegue" sender:sender];
}

- (IBAction)searchFoodButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"shopListSegue" sender:sender];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"loginSegue" sender:sender];
}

- (IBAction)userToolButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"userToolSegue" sender:sender];
}

- (IBAction)homeButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
