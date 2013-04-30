//
//  BKAccountActivationViewController.m
//  Blink
//
//  Created by 維平 廖 on 13/4/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAccountActivationViewController.h"
#import "UIViewController+SharedCustomizedUI.h"

@interface BKAccountActivationViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;

@end

@implementation BKAccountActivationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[self viewBackgoundColor]];
    [self.titleBackground setImage:[self titleImage]];
}

@end
