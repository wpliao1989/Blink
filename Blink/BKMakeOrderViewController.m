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
#import "BKMenuItem.h"
#import "BKItemSelectButton.h"

#import "BKTestCenter.h"

@interface BKMakeOrderViewController ()

- (IBAction)makeOrderButtonPressed:(id)sender;
- (IBAction)noteButtonPressed:(id)sender;
- (IBAction)addOrderContentButtonPressed:(id)sender;
- (IBAction)selectItemButtonPressed:(id)sender;
- (IBAction)selectIceButtonPressed:(id)sender;
- (IBAction)selectSweetnessButtonPressed:(id)sender;
- (IBAction)selectQuantityButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *orderContent;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *itemButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *iceButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *sweetnessButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *quantityButton;
@property (strong, nonatomic) IBOutlet UIPickerView *itemPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *icePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *sweetnessPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *quantityPicker;

@property (strong, nonatomic) NSArray *quantityLevels;
@property (strong, nonatomic) BKMenuItem *selectedMenuItem;
@property (strong, nonatomic) NSString *selectedItemName;
@property (strong, nonatomic) NSString *selectedIceLevel;
@property (strong, nonatomic) NSString *selectedSweetness;
@property (strong, nonatomic) NSNumber *selectedQuantity;

- (void)totalPriceDidChange;
- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice;
- (void)initButtons;

@end

@implementation BKMakeOrderViewController

@synthesize orderContent = _orderContent;
@synthesize menu = _menu;
@synthesize quantityLevels = _quantityLevels;
@synthesize selectedItemName = _selectedItemName;
@synthesize selectedIceLevel = _selectedIceLevel;
@synthesize selectedSweetness = _selectedSweetness;
@synthesize selectedQuantity = _selectedQuantity;

- (NSArray *)quantityLevels {
    if (_quantityLevels == nil) {
        NSMutableArray *newQLs = [NSMutableArray array];
        for (int i = 1; i <= 99; i++) {
            [newQLs addObject:[NSNumber numberWithInt:i]];
        }
        _quantityLevels = [NSArray arrayWithArray:newQLs];
    }
    return _quantityLevels;
}

- (void)setSelectedItemName:(NSString *)selectedItemName {
    _selectedItemName = selectedItemName;
    [self.itemButton setTitle:selectedItemName forState:UIControlStateNormal];
    [self.itemButton setTitle:selectedItemName forState:UIControlStateSelected];
    [self.itemButton setTitle:selectedItemName forState:UIControlStateHighlighted];
}

- (void)setSelectedIceLevel:(NSString *)selectedIceLevel {
    _selectedIceLevel = selectedIceLevel;
    [self.iceButton setTitle:selectedIceLevel forState:UIControlStateNormal];
    [self.iceButton setTitle:selectedIceLevel forState:UIControlStateSelected];
    [self.iceButton setTitle:selectedIceLevel forState:UIControlStateHighlighted];
}

- (void)setSelectedSweetness:(NSString *)selectedSweetness {
    _selectedSweetness = selectedSweetness;
    [self.sweetnessButton setTitle:selectedSweetness forState:UIControlStateNormal];
    [self.sweetnessButton setTitle:selectedSweetness forState:UIControlStateSelected];
    [self.sweetnessButton setTitle:selectedSweetness forState:UIControlStateHighlighted];
}

- (void)setSelectedQuantity:(NSNumber *)selectedQuantity {
    _selectedQuantity = selectedQuantity;
    [self.quantityButton setTitle:[selectedQuantity stringValue] forState:UIControlStateNormal];
    [self.quantityButton setTitle:[selectedQuantity stringValue] forState:UIControlStateSelected];
    [self.quantityButton setTitle:[selectedQuantity stringValue] forState:UIControlStateHighlighted];
}

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
    
//    NSLog(@"totalPrice is %@", [[BKOrderManager sharedBKOrderManager] totalPrice]);
//    NSLog(@"string value is %@", [[[BKOrderManager sharedBKOrderManager] totalPrice] stringValue]);
    self.totalPrice.text = [self stringForTotalPrice:[[BKOrderManager sharedBKOrderManager] totalPrice]];
    [self initButtons];
    
    for (BKMenuItem *item in self.menu) {
        NSLog(@"name of item is %@", item.name);
    }
}

- (void)initButtons {
    self.itemButton.inputView = self.itemPicker;    
    self.iceButton.inputView = self.icePicker;
    self.sweetnessButton.inputView = self.sweetnessPicker;
    self.quantityButton.inputView = self.quantityPicker;
//    self.quantityButton.titleLabel.text = [[self.quantityLevels objectAtIndex:0] stringValue];
//    [self.quantityButton setTitle:[[self.quantityLevels objectAtIndex:0] stringValue] forState:UIControlStateNormal];
//    [self.quantityButton setTitle:[[self.quantityLevels objectAtIndex:0] stringValue] forState:UIControlStateSelected];
//    [self.quantityButton setTitle:[[self.quantityLevels objectAtIndex:0] stringValue] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(totalPriceDidChange) name:kBKTotalPriceDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Total price did change

- (void)totalPriceDidChange {
//    NSLog(@"totalPriceDidChange!");
    NSNumber *totalPrice = [[BKOrderManager sharedBKOrderManager] totalPrice];
    self.totalPrice.text = [self stringForTotalPrice:totalPrice];
}

- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice {
    static NSString *preString = @"總金額: ";
    static NSString *postString = @"元";
    NSString *result = [[preString stringByAppendingString:[totalPrice stringValue]] stringByAppendingString:postString];
    return result;
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

#pragma mark - Picker view dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 1;
    
    if (pickerView == self.itemPicker) {
        count = self.menu.count;
    }else if (pickerView == self.icePicker) {
//        count = self.menu
    }else if (pickerView == self.sweetnessPicker) {
        
    }else if (pickerView == self.quantityPicker) {
        count = self.quantityLevels.count;
    }
    
    return count;
}

#pragma mark - Picker view delegate

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    BKMenuItem *theItem = [self.menu objectAtIndex:row];
//    return theItem.name;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"picker didSelectRow %d", row);
    if (pickerView == self.itemPicker) {
        
        BKMenuItem *theItem = [self.menu objectAtIndex:row];
        self.selectedMenuItem = theItem;
        self.selectedItemName = theItem.name;
        [self.icePicker reloadAllComponents];
        [self.sweetnessPicker reloadAllComponents];
        
    }else if (pickerView == self.icePicker) {
        
    }else if (pickerView == self.sweetnessPicker) {
        
    }else if (pickerView == self.quantityPicker) {
        
        NSNumber *theNumber = [self.quantityLevels objectAtIndex:row];
        NSLog(@"theNumber stringValue = %@", [theNumber stringValue]);
        self.selectedQuantity = theNumber;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    if (pickerView == self.itemPicker) {
        
        BKMenuItem *theItem = [self.menu objectAtIndex:row];
        label.text = theItem.name;        
        
    }else if (pickerView == self.icePicker) {
        
        if (self.selectedMenuItem != nil) {
            NSLog(@"%@", self.selectedMenuItem.iceLevels);
        }
        
    }else if (pickerView == self.sweetnessPicker) {
        
    }else if (pickerView == self.quantityPicker) {
        
        NSNumber *theNumber = [self.quantityLevels objectAtIndex:row];
        label.text = [theNumber stringValue];
        
    }
    
    return label;
}

#pragma IBActions

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
    note.note = [[BKOrderManager sharedBKOrderManager] note];
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
    
    [self.orderContent scrollToRowAtIndexPath:indexPathToBeInserted atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (IBAction)selectItemButtonPressed:(id)sender {    
    [self.itemButton becomeFirstResponder];
}

- (IBAction)selectIceButtonPressed:(id)sender {    
    [self.iceButton becomeFirstResponder];
}

- (IBAction)selectSweetnessButtonPressed:(id)sender {    
    [self.sweetnessButton becomeFirstResponder];
}

- (IBAction)selectQuantityButtonPressed:(id)sender {    
    [self.quantityButton becomeFirstResponder];
}
@end
