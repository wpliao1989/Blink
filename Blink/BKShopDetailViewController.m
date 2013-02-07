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
- (IBAction)orderDeliverButtonPressed:(id)sender;
- (IBAction)takeAwayButtonPressed:(id)sender;

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
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    if(editing == YES){
//        self.editButtonItem.title = @"完成";
//    }else {
//        self.editButtonItem.title = @"編輯";
//    }
//}

- (IBAction)menuButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"menuSegue" sender:self];
}

- (IBAction)orderDeliverButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"makeOrderSegue" sender:self];
}

- (IBAction)takeAwayButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"makeOrderSegue" sender:self];
}
@end
