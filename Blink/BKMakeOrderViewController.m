//
//  BKMakeOrderViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/4.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMakeOrderViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "BKAccountManager.h"
#import "BKMainPageViewController.h"
#import "BKNoteViewController.h"



@interface BKMakeOrderViewController ()

- (IBAction)makeOrderButtonPressed:(id)sender;
- (IBAction)noteButtonPressed:(id)sender;

@end

@implementation BKMakeOrderViewController

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
    self.navigationItem.rightBarButtonItem = ((BKMainPageViewController *)[self.navigationController.viewControllers objectAtIndex:0]).homeButton;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeOrderButtonPressed:(id)sender {
    if ([BKAccountManager sharedBKAccountManager].isLogin) {
        [self performSegueWithIdentifier:@"orderConfirmSegue" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"fromOrderToLoginSegue" sender:self];
    }

}

- (IBAction)noteButtonPressed:(id)sender {
    BKNoteViewController *note = [self.storyboard instantiateViewControllerWithIdentifier:@"BKNoteVC"];
    
//    NSLog(@"%@", NSStringFromCGRect(note.view.frame));
//    note.view.bounds = CGRectMake(0, 0, 300, 400);
//    NSLog(@"%@", note);
//    if([self respondsToSelector:@selector(presentPopupViewController:animationType:)]) {
//        NSLog(@"YES");
//    }
//    else {
//        NSLog(@"NO");
//    }
    [self presentPopupViewController:note animationType:MJPopupViewAnimationSlideBottomBottom];
}
@end
