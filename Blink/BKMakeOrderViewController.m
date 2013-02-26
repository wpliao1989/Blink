//
//  BKMakeOrderViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/4.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMakeOrderViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "BKOrderConfirmViewController.h"
#import "BKAccountManager.h"
#import "BKMainPageViewController.h"
#import "BKNoteViewController.h"
#import "BKOrderManager.h"
#import "BKOrderContent.h"
#import "BKMenuItem.h"
#import "BKItemSelectButton.h"
#import "BKShopInfo.h"

#import "BKTestCenter.h"

typedef NS_ENUM(NSInteger, BKSelectionCode) {
    BKSelectionValid = 1,
    BKSelectionItemNotSelected = 2,
    BKSelectionIceNotSelected = 3,
    BKSelectionSweetnessNotSelected = 4
};

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

@property (strong, readonly, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSArray *quantityLevels;
@property (strong, nonatomic) BKMenuItem *selectedMenuItem;
@property (strong, nonatomic) NSString *selectedItemName;
@property (strong, nonatomic) NSString *selectedIceLevel;
@property (strong, nonatomic) NSString *selectedSweetness;
@property (strong, nonatomic) NSNumber *selectedQuantity;

@property (strong, nonatomic) UIAlertView *orderExistAlert;
@property (strong, nonatomic) UIAlertView *inValidSelectionAlert;
@property (strong, nonatomic) UIAlertView *notEnoughContentAlert;

- (void)totalPriceDidChange;
- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice;
- (void)initSettings;
- (void)updateSelectedMenuItemWithRow:(NSInteger)row;
- (void)updateSelectedIceWithRow:(NSInteger)row;
- (void)updateSelectedSweetnessWithRow:(NSInteger)row;
- (void)updateSelectedQuantityWithRow:(NSInteger)row;
- (void)addOrderContent;
- (NSArray *)inValidSelectionCodes;
- (NSString *)inValidMessage;
- (void)changeButtonTitleButton:(UIButton *)button title:(NSString *)title;

// For test purposes
- (void)testPrint;

@end

static NSString *noSelectableItem = @"無可選擇項目";
//static NSString *iceUnselected = @"冰量";
//static NSString *sweetnessUnselected = @"糖量";

@implementation BKMakeOrderViewController

@synthesize orderContent = _orderContent;
@synthesize menu = _menu;
@synthesize quantityLevels = _quantityLevels;
@synthesize selectedItemName = _selectedItemName;
@synthesize selectedIceLevel = _selectedIceLevel;
@synthesize selectedSweetness = _selectedSweetness;
@synthesize selectedQuantity = _selectedQuantity;

@synthesize orderExistAlert = _orderExistAlert;
@synthesize inValidSelectionAlert = _inValidSelectionAlert;
@synthesize notEnoughContentAlert = _notEnoughContentAlert;

- (UIAlertView *)orderExistAlert {
    if (_orderExistAlert == nil) {
        _orderExistAlert = [[UIAlertView alloc] initWithTitle:@"Blink" message:@"Order exists. Delete order?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Delete", nil];
    }
    return _orderExistAlert;
}

- (UIAlertView *)inValidSelectionAlert {
    if (_inValidSelectionAlert == nil) {
        _inValidSelectionAlert = [[UIAlertView alloc] initWithTitle:@"Blink" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    return _inValidSelectionAlert;
}

- (UIAlertView *)notEnoughContentAlert {
    if (_notEnoughContentAlert == nil) {
        _notEnoughContentAlert = [[UIAlertView alloc] initWithTitle:@"Blink" message:@"Not enough content" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    return _notEnoughContentAlert;
}

- (NSArray *)menu {
    return self.shopInfo.menu;
}

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
    [self changeButtonTitleButton:self.itemButton title:selectedItemName];
//    [self.itemButton setTitle:selectedItemName forState:UIControlStateNormal];
//    [self.itemButton setTitle:selectedItemName forState:UIControlStateSelected];
//    [self.itemButton setTitle:selectedItemName forState:UIControlStateHighlighted];
}

- (void)setSelectedIceLevel:(NSString *)selectedIceLevel {
    _selectedIceLevel = selectedIceLevel;
    [self changeButtonTitleButton:self.iceButton title:selectedIceLevel];
//    [self.iceButton setTitle:selectedIceLevel forState:UIControlStateNormal];
//    [self.iceButton setTitle:selectedIceLevel forState:UIControlStateSelected];
//    [self.iceButton setTitle:selectedIceLevel forState:UIControlStateHighlighted];
}

- (void)setSelectedSweetness:(NSString *)selectedSweetness {
    _selectedSweetness = selectedSweetness;
    [self changeButtonTitleButton:self.sweetnessButton title:selectedSweetness];
//    [self.sweetnessButton setTitle:selectedSweetness forState:UIControlStateNormal];
//    [self.sweetnessButton setTitle:selectedSweetness forState:UIControlStateSelected];
//    [self.sweetnessButton setTitle:selectedSweetness forState:UIControlStateHighlighted];
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
    [self initSettings];
}

- (void)initSettings {
    [self.orderContent setEditing:YES animated:NO];
    
    //    NSLog(@"totalPrice is %@", [[BKOrderManager sharedBKOrderManager] totalPrice]);
    //    NSLog(@"string value is %@", [[[BKOrderManager sharedBKOrderManager] totalPrice] stringValue]);
    self.totalPrice.text = [self stringForTotalPrice:[[BKOrderManager sharedBKOrderManager] totalPrice]];    
    
    for (BKMenuItem *item in self.menu) {
        NSLog(@"name of item is %@", item.name);
    }        
    
    self.itemButton.inputView = self.itemPicker;    
    self.iceButton.inputView = self.icePicker;
    self.sweetnessButton.inputView = self.sweetnessPicker;
    self.quantityButton.inputView = self.quantityPicker;
//    self.quantityButton.titleLabel.text = [[self.quantityLevels objectAtIndex:0] stringValue];
//    [self.quantityButton setTitle:[[self.quantityLevels objectAtIndex:0] stringValue] forState:UIControlStateNormal];
//    [self.quantityButton setTitle:[[self.quantityLevels objectAtIndex:0] stringValue] forState:UIControlStateSelected];
//    [self.quantityButton setTitle:[[self.quantityLevels objectAtIndex:0] stringValue] forState:UIControlStateHighlighted];
    [self updateSelectedQuantityWithRow:0];
    
    [self testPrint];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"orderConfirmSegue"]) {
        BKOrderConfirmViewController *orderConfirmVC = segue.destinationViewController;
        orderConfirmVC.shopInfo = self.shopInfo;
    }
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
    return [[BKOrderManager sharedBKOrderManager] numberOfOrderContentsForShopInfo:self.shopInfo];
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
        
        if (self.menu.count > 0) {
            count = self.menu.count;
        }        
        
    }else if (pickerView == self.icePicker) {
//        count = self.menu
        
        if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.iceLevels.count > 0)) {
            count = self.selectedMenuItem.iceLevels.count;
        }
        
    }else if (pickerView == self.sweetnessPicker) {
        
        if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.sweetnessLevels.count > 0)) {
            count = self.selectedMenuItem.sweetnessLevels.count;
        }
        
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

        [self updateSelectedMenuItemWithRow:row];
//        BKMenuItem *theItem = [self.menu objectAtIndex:row];
//        self.selectedMenuItem = theItem;
//        self.selectedItemName = theItem.name;
//        [self.icePicker reloadAllComponents];
//        [self.sweetnessPicker reloadAllComponents];
        
    }else if (pickerView == self.icePicker) {
        
        [self updateSelectedIceWithRow:row];
//        if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.iceLevels.count > 0)) {
//            self.selectedIceLevel = [self.selectedMenuItem.iceLevels objectAtIndex:row];
//        }        
        
    }else if (pickerView == self.sweetnessPicker) {
        
        [self updateSelectedSweetnessWithRow:row];
//        if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.sweetnessLevels.count > 0)) {
//            self.selectedSweetness = [self.selectedMenuItem.sweetnessLevels objectAtIndex:row];
//        }
        
    }else if (pickerView == self.quantityPicker) {
        
        [self updateSelectedQuantityWithRow:row];
//        NSNumber *theNumber = [self.quantityLevels objectAtIndex:row];
//        NSLog(@"theNumber stringValue = %@", [theNumber stringValue]);
//        self.selectedQuantity = theNumber;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];    
    
    if (pickerView == self.itemPicker) {
        
        if (self.menu.count > 0) {
            BKMenuItem *theItem = [self.menu objectAtIndex:row];
            label.text = theItem.name;
        }
        else {
            label.text = noSelectableItem;
        }
        
        
    }else if (pickerView == self.icePicker) {
        
        if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.iceLevels.count > 0)) {
            NSLog(@"%@", self.selectedMenuItem.iceLevels);
            label.text = [self.selectedMenuItem.iceLevels objectAtIndex:row];
        }
        else {
            label.text = noSelectableItem;
        }
        
    }else if (pickerView == self.sweetnessPicker) {
        
        if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.sweetnessLevels.count > 0)) {
            NSLog(@"%@", self.selectedMenuItem.sweetnessLevels);
            label.text = [self.selectedMenuItem.sweetnessLevels objectAtIndex:row];
        }
        else {
            label.text = noSelectableItem;
        }
        
    }else if (pickerView == self.quantityPicker) {
        
        NSNumber *theNumber = [self.quantityLevels objectAtIndex:row];
        label.text = [theNumber stringValue];
        
    }
    
    return label;
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.orderExistAlert) {
        NSLog(@"orderExistAlert button pressed: %d", buttonIndex);
        NSInteger confirmDelete = 1;
        if (buttonIndex == confirmDelete) {
            [[BKOrderManager sharedBKOrderManager] clear];
        }
    }
}

#pragma mark - Utility methods

- (void)updateSelectedMenuItemWithRow:(NSInteger)row {
    if (self.menu.count > 0) {
        BKMenuItem *theItem = [self.menu objectAtIndex:row];
        if (theItem != self.selectedMenuItem) {
            self.selectedMenuItem = theItem;
            self.selectedItemName = theItem.name;
            if (theItem.iceLevels.count == 0) {
//                NSLog(@"1");
                self.selectedIceLevel = nil;
                [self.iceButton setEnabled:NO];
                [self changeButtonTitleButton:self.iceButton title:noSelectableItem];
            }
            else {
//                NSLog(@"2");
                [self.iceButton setEnabled:YES];
                [self.icePicker selectRow:0 inComponent:0 animated:NO];
                [self pickerView:self.icePicker didSelectRow:0 inComponent:0];
            }
            if (theItem.sweetnessLevels.count == 0) {
//                NSLog(@"3");
                self.selectedSweetness = nil;
                [self.sweetnessButton setEnabled:NO];
                [self changeButtonTitleButton:self.sweetnessButton title:noSelectableItem];
            }
            else {
//                NSLog(@"4");
                [self.sweetnessButton setEnabled:YES];
                [self.sweetnessPicker selectRow:0 inComponent:0 animated:NO];
                [self pickerView:self.sweetnessPicker didSelectRow:0 inComponent:0];
            }
            
            [self.icePicker reloadAllComponents];
            [self.sweetnessPicker reloadAllComponents];
        }        
    }    
}

- (void)updateSelectedIceWithRow:(NSInteger)row {
    if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.iceLevels.count > 0)) {
        self.selectedIceLevel = [self.selectedMenuItem.iceLevels objectAtIndex:row];
    }
}

- (void)updateSelectedSweetnessWithRow:(NSInteger)row {
    if ((self.selectedMenuItem != nil) && (self.selectedMenuItem.sweetnessLevels.count > 0)) {
        self.selectedSweetness = [self.selectedMenuItem.sweetnessLevels objectAtIndex:row];
    }
}

- (void)updateSelectedQuantityWithRow:(NSInteger)row {
    NSNumber *theNumber = [self.quantityLevels objectAtIndex:row];
    NSLog(@"theNumber stringValue = %@", [theNumber stringValue]);
    self.selectedQuantity = theNumber;
}

- (void)addOrderContent {
//    [[BKOrderManager sharedBKOrderManager] addNewOrderContent:[BKTestCenter testOrderContent]];
    if ([self inValidSelectionCodes] == nil){
        [self testPrint];
        
        BKOrderContent *newOrderContent = [[BKOrderContent alloc] initWithMenu:self.selectedMenuItem
                                                                           ice:self.selectedIceLevel
                                                                     sweetness:self.selectedSweetness
                                                                      quantity:self.selectedQuantity];
        BOOL success = [[BKOrderManager sharedBKOrderManager] addNewOrderContent:newOrderContent forShopInfo:self.shopInfo completeHandler:^(NSInteger updatedRow, BOOL isNewItemAdded) {
            NSIndexPath *indexPathToBeUpdated = [NSIndexPath indexPathForRow:updatedRow inSection:0];
            if (isNewItemAdded) {
                [self.orderContent insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToBeUpdated] withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                [self.orderContent reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToBeUpdated] withRowAnimation:UITableViewRowAnimationAutomatic];
            }            
            [self.orderContent scrollToRowAtIndexPath:indexPathToBeUpdated atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }];
        
        if (!success) {
            NSLog(@"not success");
            [self.orderExistAlert show];
        }
        
//        [self.orderContent reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//        NSInteger row = [[BKOrderManager sharedBKOrderManager] numberOfOrderContents] - 1;
//         NSLog(@"%d", row);
//        NSIndexPath *indexPathToBeInserted = [NSIndexPath indexPathForRow:row inSection:0];
//        [self.orderContent insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToBeInserted] withRowAnimation:UITableViewRowAnimationTop];
//        
//        [self.orderContent scrollToRowAtIndexPath:indexPathToBeInserted atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    else {
        NSLog(@"Not a valid selection!");
        [self testPrint];
        [self.inValidSelectionAlert setMessage:[self inValidMessage]];
        [self.inValidSelectionAlert show];
    }   
}

- (NSArray *)inValidSelectionCodes {
    NSMutableArray *result = [NSMutableArray array];
    
    if (self.selectedMenuItem == nil) {
//        NSLog(@"%@", [NSNumber numberWithInt:BKSelectionItemNotSelected]);
        [result addObject:[NSNumber numberWithInt:BKSelectionItemNotSelected]];
//        return BKSelectionItemNotSelected;
    }
    else {
        if ((self.selectedMenuItem.iceLevels.count > 0) && (self.selectedIceLevel == nil)) {
//            NSLog(@"%@", [NSNumber numberWithInt:BKSelectionIceNotSelected]);
            [result addObject:[NSNumber numberWithInt:BKSelectionIceNotSelected]];
//            return BKSelectionIceNotSelected;
        }
        if ((self.selectedMenuItem.sweetnessLevels.count > 0) && (self.selectedSweetness == nil)) {
//            NSLog(@"%@", [NSNumber numberWithInt:BKSelectionSweetnessNotSelected]);
            [result addObject:[NSNumber numberWithInt:BKSelectionSweetnessNotSelected]];
//            return BKSelectionSweetnessNotSelected;
        }
    }
    
    NSLog(@"inValidSelectionCodes: %@", result);
    
    if (result.count == 0) {
        return nil;
    }
    else {
        return result;
    }
}

- (NSString *)inValidMessage {
    static NSString *itemNotSelected = @"Item not selected";
    static NSString *iceNotSelected = @"Ice level not selected";
    static NSString *sweetnessNotSelected = @"Sweetness not selected";
    static NSString *changeLine = @"\n";
    
    NSString *result = @"";
    
    NSArray *inValidSelectionCodes = [self inValidSelectionCodes];
 
    for (int i=0 ; i < inValidSelectionCodes.count; i++) {
        NSNumber *number = [inValidSelectionCodes objectAtIndex:i];
        
        switch ([number intValue]) {
            case BKSelectionItemNotSelected:
                result = [result stringByAppendingString:itemNotSelected];                
                break;
                
            case BKSelectionIceNotSelected:
                result = [result stringByAppendingString:iceNotSelected];  
                break;
                
            case BKSelectionSweetnessNotSelected:
                result = [result stringByAppendingString:sweetnessNotSelected];  
                break;
                
            default:
                break;
        }
        
        if (i != inValidSelectionCodes.count - 1) {
            result = [result stringByAppendingString:changeLine];
        }
    }
    
    return result;
}

- (void)changeButtonTitleButton:(UIButton *)button title:(NSString *)title {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateHighlighted];
}

- (void)testPrint {
    NSLog(@"selectedItemName: %@", self.selectedItemName);
    NSLog(@"selectedIce: %@", self.selectedIceLevel);
    NSLog(@"selectedSweetness: %@", self.selectedSweetness);
    NSLog(@"selectedQuantity: %@", self.selectedQuantity);
}

#pragma mark - IBActions

- (IBAction)makeOrderButtonPressed:(id)sender {
    if ([[BKOrderManager sharedBKOrderManager] numberOfOrderContentsForShopInfo:self.shopInfo] == 0) {
        [self.notEnoughContentAlert show];
    }
    else {
        if ([BKAccountManager sharedBKAccountManager].isLogin) {
            [self performSegueWithIdentifier:@"orderConfirmSegue" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"fromOrderToLoginSegue" sender:self];
        }
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
    [self addOrderContent];
}

- (IBAction)selectItemButtonPressed:(id)sender {
    NSInteger row = [self.itemPicker selectedRowInComponent:0];
    [self updateSelectedMenuItemWithRow:row];
    [self.itemButton becomeFirstResponder];
}

- (IBAction)selectIceButtonPressed:(id)sender {
    NSInteger row = [self.icePicker selectedRowInComponent:0];
    [self updateSelectedIceWithRow:row];
    [self.iceButton becomeFirstResponder];
}

- (IBAction)selectSweetnessButtonPressed:(id)sender {
    NSInteger row = [self.sweetnessPicker selectedRowInComponent:0];
    [self updateSelectedSweetnessWithRow:row];
    [self.sweetnessButton becomeFirstResponder];
}

- (IBAction)selectQuantityButtonPressed:(id)sender {
    NSInteger row = [self.quantityPicker selectedRowInComponent:0];
    [self updateSelectedQuantityWithRow:row];
    [self.quantityButton becomeFirstResponder];
}
@end
