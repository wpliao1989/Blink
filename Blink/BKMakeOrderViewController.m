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
#import "BKOrderManager.h"
#import "BKOrderContent.h"

#import "BKTestCenter.h"

@interface BKMakeOrderViewController ()

- (IBAction)makeOrderButtonPressed:(id)sender;
- (IBAction)noteButtonPressed:(id)sender;
- (IBAction)addOrderContentButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *orderContent;

@end

@implementation BKMakeOrderViewController

@synthesize orderContent = _orderContent;

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
    [self.orderContent setEditing:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BKOrderManager sharedBKOrderManager] numberOfOrderContents];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    UILabel *ice = (UILabel *)[cell viewWithTag:2];
    UILabel *sweetness = (UILabel *)[cell viewWithTag:3];
    UILabel *quantity = (UILabel *)[cell viewWithTag:4];
    UILabel *price = (UILabel *)[cell viewWithTag:5];
    
    BKOrderContent *orderContent = [[BKOrderManager sharedBKOrderManager] orderContentAtIndex:indexPath.row];
    name.text = orderContent.name;
    ice.text = orderContent.ice;
    sweetness.text = orderContent.sweetness;
    quantity.text = [orderContent.quantity stringValue];
    price.text = orderContent.price;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[BKOrderManager sharedBKOrderManager] deleteOrderContentAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
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

- (IBAction)addOrderContentButtonPressed:(id)sender {
    [[BKOrderManager sharedBKOrderManager] addNewOrderContent:[BKTestCenter testOrderContent]];
    
    NSInteger row = [[BKOrderManager sharedBKOrderManager] numberOfOrderContents] - 1;
//    NSLog(@"%d", row);
    NSIndexPath *indexPathToBeInserted = [NSIndexPath indexPathForRow:row inSection:0];
    [self.orderContent insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToBeInserted] withRowAnimation:UITableViewRowAnimationTop];
}
@end
