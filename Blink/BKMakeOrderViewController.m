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
#import "BKOrderContentForSending.h"
#import "BKMenuItem.h"
#import "BKItemSelectButton.h"
#import "BKShopInfo.h"
#import "BKShopInfoManager.h"
#import "UIViewController+BKBaseViewController.h"

#import "BKTestCenter.h"

typedef NS_ENUM(NSInteger, BKSelectionCode) {
    BKSelectionValid = 1,
    BKSelectionItemNotSelected = 2,
    BKSelectionIceNotSelected = 3,
    BKSelectionSweetnessNotSelected = 4
};

NSInteger iceComponent = 0;
NSInteger sweetnessComponent = 1;
NSInteger sizeComponent = 1;
NSInteger quantityComponent = 0;

@interface BKMakeOrderViewController()<BKNoteViewDelegate>

- (IBAction)makeOrderButtonPressed:(id)sender;
- (IBAction)noteButtonPressed:(id)sender;
- (IBAction)addOrderContentButtonPressed:(id)sender;
- (IBAction)selectItemButtonPressed:(id)sender;
- (IBAction)selectIceAndSweetnessButtonPressed:(id)sender;
- (IBAction)selectSizeAndQuantityButtonPressed:(id)sender;
- (IBAction)selectQuantityButtonPressed:(id)sender;
- (IBAction)selectTimeButtonPressed:(id)sender;
- (IBAction)timePickerValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UITableView *orderContent;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *minDeliveryCostLabel;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *itemButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *iceAndSweetnessButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *sizeAndQuantityButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *quantityButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *timeButton;
@property (strong, nonatomic) IBOutlet UIPickerView *itemPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *iceAndSweetnessPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *sizeAndQuantityPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *quantityPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;

@property (strong, nonatomic) BKShopInfo *shopInfo;
@property (strong, readonly, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSArray *quantityLevels;
@property (strong, nonatomic) BKMenuItem *selectedMenuItem;
@property (strong, nonatomic) NSString *selectedItemName;
@property (strong, nonatomic) NSString *selectedIceLevel;
@property (strong, nonatomic) NSString *selectedSweetness;
@property (strong, nonatomic) NSNumber *selectedQuantity;
@property (strong, nonatomic) NSString *selectedSize;
@property (strong, nonatomic) NSDate *selectedTime;

@property (strong, nonatomic) UIAlertView *orderExistAlert;
@property (strong, nonatomic) UIAlertView *inValidSelectionAlert;
@property (strong, nonatomic) UIAlertView *notEnoughContentAlert;

- (void)totalPriceDidChange;
- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice;
- (NSString *)stringForDeliveryCostLabelCost:(NSNumber *)cost;
- (void)initSettings;
- (void)initButtons;
- (void)initTimePicker;

// Picker related
- (void)updateSelectedMenuItemWithRow:(NSInteger)row;
- (void)updateSelectedIceWithRow:(NSInteger)row;
- (void)updateSelectedSweetnessWithRow:(NSInteger)row;
- (void)updateSelectedQuantityWithRow:(NSInteger)row;
- (void)updateSelectedSizeWithRow:(NSInteger)row;
- (void)updateSelectedTimeWithDate:(NSDate *)date;

- (void)addOrderContent;
- (NSArray *)inValidSelectionCodes;
- (NSString *)inValidMessage;
- (NSString *)orderExistsMessage;
- (NSString *)currencyStringForPrice:(NSNumber *)price;

- (void)changeButtonTitleButton:(UIButton *)button title:(NSString *)title;
- (void)updateIceAndSweetnessButtonTitle;
- (void)updateSizeAndQuantityButtonTitle;
- (void)updateTimeButtonTitle;

- (BOOL)hasSelectableIce;
- (BOOL)hasSelectableSweetness;
- (BOOL)hasSelectableSize;

// For test purposes
- (void)testPrint;

@end

static NSString *noSelectableItem = @"無可選擇項目";
//static NSString *iceUnselected = @"冰量";
//static NSString *sweetnessUnselected = @"糖量";

@implementation BKMakeOrderViewController

@synthesize orderContent = _orderContent;
@synthesize shopInfo = _shopInfo;
@synthesize menu = _menu;
@synthesize quantityLevels = _quantityLevels;
@synthesize selectedItemName = _selectedItemName;
@synthesize selectedIceLevel = _selectedIceLevel;
@synthesize selectedSweetness = _selectedSweetness;
@synthesize selectedQuantity = _selectedQuantity;
@synthesize selectedSize = _selectedSize;

@synthesize orderExistAlert = _orderExistAlert;
@synthesize inValidSelectionAlert = _inValidSelectionAlert;
@synthesize notEnoughContentAlert = _notEnoughContentAlert;

- (UIAlertView *)orderExistAlert {
    if (_orderExistAlert == nil) {
        _orderExistAlert = [[UIAlertView alloc] initWithTitle:@"Blink" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刪除", nil];
    }
    return _orderExistAlert;
}

- (UIAlertView *)inValidSelectionAlert {
    if (_inValidSelectionAlert == nil) {
        _inValidSelectionAlert = [[UIAlertView alloc] initWithTitle:@"Blink" message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
    }
    return _inValidSelectionAlert;
}

- (UIAlertView *)notEnoughContentAlert {
    if (_notEnoughContentAlert == nil) {
        _notEnoughContentAlert = [[UIAlertView alloc] initWithTitle:@"Blink" message:@"請至少選擇一項商品" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
    }
    return _notEnoughContentAlert;
}

- (BKShopInfo *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
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
}

- (void)setSelectedIceLevel:(NSString *)selectedIceLevel {
    _selectedIceLevel = selectedIceLevel;
    [self updateIceAndSweetnessButtonTitle];
}

- (void)setSelectedSweetness:(NSString *)selectedSweetness {
    _selectedSweetness = selectedSweetness;
    [self updateIceAndSweetnessButtonTitle];
}

- (void)setSelectedQuantity:(NSNumber *)selectedQuantity {
    _selectedQuantity = selectedQuantity;
    [self updateSizeAndQuantityButtonTitle];
}

- (void)setSelectedSize:(NSString *)selectedSize {
    _selectedSize = selectedSize;
    [self updateSizeAndQuantityButtonTitle];
}

- (void)setSelectedTime:(NSDate *)selectedTime {
    _selectedTime = selectedTime;
    [self updateTimeButtonTitle];
}

#pragma mark - View controller life cycle

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
//    [self addHomeButton];    
    [self initSettings];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
    [self.background setImage:[[UIImage imageNamed:@"list_try"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 14, 67, 20)]];
}

- (void)initSettings {
    [self.orderContent setEditing:YES animated:NO];
    
    //    NSLog(@"totalPrice is %@", [[BKOrderManager sharedBKOrderManager] totalPrice]);
    //    NSLog(@"string value is %@", [[[BKOrderManager sharedBKOrderManager] totalPrice] stringValue]);
    self.shopNameLabel.text = self.shopInfo.name;
    self.totalPrice.text = [self stringForTotalPrice:[[BKOrderManager sharedBKOrderManager] totalPriceForShop:self.shopInfo]];
    self.minDeliveryCostLabel.text = [self stringForDeliveryCostLabelCost:self.shopInfo.minPrice];
    
    [self initButtons];
    [self initTimePicker];

    [self updateSelectedQuantityWithRow:0];
    [self updateSelectedMenuItemWithRow:0];
    
    [self testPrint];
}

- (void)initButtons {
    // Configure input views
    self.itemButton.inputView = self.itemPicker;
    self.iceAndSweetnessButton.inputView = self.iceAndSweetnessPicker;
    self.sizeAndQuantityButton.inputView = self.sizeAndQuantityPicker;
//    self.quantityButton.inputView = self.quantityPicker;
    self.timeButton.inputView = self.timePicker;
    
//    [self.itemButton setBackgroundImage:[[UIImage imageNamed:@"pull"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 11, 5, 21)] forState:UIControlStateNormal];
    UIImage *background = [[UIImage imageNamed:@"pull"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 21)];
    UIImage *backgroundPress = [[UIImage imageNamed:@"pull_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 21)];
    
    [self.itemButton setBackgroundImage:background forState:UIControlStateNormal];
    [self.itemButton setBackgroundImage:backgroundPress forState:UIControlStateHighlighted];
    
    [self.iceAndSweetnessButton setBackgroundImage:background forState:UIControlStateNormal];
    [self.iceAndSweetnessButton setBackgroundImage:backgroundPress forState:UIControlStateHighlighted];
    
    [self.sizeAndQuantityButton setBackgroundImage:background forState:UIControlStateNormal];
    [self.sizeAndQuantityButton setBackgroundImage:backgroundPress forState:UIControlStateHighlighted];
    
    [self.timeButton setBackgroundImage:background forState:UIControlStateNormal];
    [self.timeButton setBackgroundImage:backgroundPress forState:UIControlStateHighlighted];
//    [self.itemButton setBackgroundImage:[UIImage imageNamed:@"pull"] forState:UIControlStateNormal];
}

- (void)initTimePicker {
    // Configure time picker intervals
    NSInteger minInterval = self.timePicker.minuteInterval;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dayOffset = [[NSDateComponents alloc] init];
    [dayOffset setDay:30];
    
    NSDate *minDate = [NSDate date];
    NSDateComponents *minComp = [currentCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit)fromDate:minDate];
    [minComp setSecond:0];
    
    NSLog(@"minComp.minute/minInterval %f", (double)minComp.minute/(double)minInterval);
    NSLog(@"ceil :%f", ceil((double)minComp.minute/(double)minInterval));
        
    [minComp setMinute:ceil((double)minComp.minute/(double)minInterval)*minInterval];
    minDate = [currentCalendar dateFromComponents:minComp];
    
    NSDate *maxDate = [currentCalendar dateByAddingComponents:dayOffset toDate:minDate options:0];
    
    [self.timePicker setMinimumDate:minDate];
    [self.timePicker setMaximumDate:maxDate];
    
    [self updateSelectedTimeWithDate:self.timePicker.date];
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
        orderConfirmVC.shopID = self.shopID;
    }
}

#pragma mark - Total price did change

- (void)totalPriceDidChange {
//    NSLog(@"totalPriceDidChange!");
    NSNumber *totalPrice = [[BKOrderManager sharedBKOrderManager] totalPriceForShop:self.shopInfo];
    self.totalPrice.text = [self stringForTotalPrice:totalPrice];
    self.minDeliveryCostLabel.text = [self stringForDeliveryCostLabelCost:self.shopInfo.minPrice];
}

#pragma mark - String for price and delivery cost label

- (NSString *)stringForTotalPrice:(NSNumber *)totalPrice {
    static NSString *preString = @"總金額：";
    static NSString *postString = @"元";
    NSString *result = [[preString stringByAppendingString:[totalPrice stringValue]] stringByAppendingString:postString];
    return result;
}

- (NSString *)stringForDeliveryCostLabelCost:(NSNumber *)cost {
    NSNumber *totalPrice = [[BKOrderManager sharedBKOrderManager] totalPriceForShop:self.shopInfo];
    
    double totalPriceD = [totalPrice doubleValue];
    double costD = [cost doubleValue];
    
    NSString *costString = [NSString stringWithFormat:@"%0.0f", costD];
    
    if (totalPriceD >= costD) {
        return [NSString stringWithFormat:@"已達最低外送價格：%@元", costString];
    }
    else {
        return [NSString stringWithFormat:@"最低外送價格：%@元", costString];
    }
}

#pragma mark - Currency formatter

- (NSString *)currencyStringForPrice:(NSNumber *)price {
    static NSNumberFormatter *currencyFormatter;
    
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setPositiveFormat:@"¤#,###"];
        NSLocale *twLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"];
        [currencyFormatter setLocale:twLocale];
        [currencyFormatter setCurrencySymbol:@"$"];
        //        NSLog(@"positive format: %@", [currencyFormatter positiveFormat]);
    }
    
    return [currencyFormatter stringFromNumber:price];
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
    UILabel *quantityAndSize = (UILabel *)[cell viewWithTag:4];
    UILabel *price = (UILabel *)[cell viewWithTag:5];
    
    BKOrderContentForSending *orderContent = [[BKOrderManager sharedBKOrderManager] orderContentAtIndex:indexPath.row];
    name.text = orderContent.name;
    ice.text = [BKMenuItem localizedStringForIce:orderContent.ice];
    sweetness.text = [BKMenuItem localizedStringForSweetness:orderContent.sweetness];
    quantityAndSize.text = [NSString stringWithFormat:@"%@ %@", [orderContent.quantity stringValue], [orderContent localizedSize]];
    price.text = [self currencyStringForPrice:orderContent.priceValue];
    
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
    if (pickerView == self.iceAndSweetnessPicker) {
        return 2;
    }
    else if (pickerView == self.sizeAndQuantityPicker) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 1;
    
    if (pickerView == self.itemPicker) {
        
        if (self.menu.count > 0) {
            count = self.menu.count;
        }        
        
    }else if (pickerView == self.iceAndSweetnessPicker) {        
        
        if (component == iceComponent) {
            if ([self hasSelectableIce]) {
                count = self.selectedMenuItem.localizedIceLevels.count;
            }
        }        
        else if (component == sweetnessComponent) {
            if ([self hasSelectableSweetness]) {
                count = self.selectedMenuItem.localizedSweetnessLevels.count;
            }
        }    
        
    }else if (pickerView == self.sizeAndQuantityPicker) {
        
        if (component == sizeComponent) {
            if ([self hasSelectableSize]) {
                count = self.selectedMenuItem.localizedSizeLevels.count;
            }
        }
        else if (component == quantityComponent) {
            count = self.quantityLevels.count;
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
        
    }else if (pickerView == self.iceAndSweetnessPicker) {
        
        if (component == iceComponent) {
            [self updateSelectedIceWithRow:row];
        }
        else if (component == sweetnessComponent) {
            [self updateSelectedSweetnessWithRow:row];
        }     
        
    }else if (pickerView == self.sizeAndQuantityPicker) {
        
        if (component == sizeComponent) {
            [self updateSelectedSizeWithRow:row];
        }
        else if (component == quantityComponent) {
            [self updateSelectedQuantityWithRow:row];
        }
        
    }else if (pickerView == self.quantityPicker) {
        
        [self updateSelectedQuantityWithRow:row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    }  
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = noSelectableItem;
    
    if (pickerView == self.itemPicker) {
        
        if (self.menu.count > 0) {
            BKMenuItem *theItem = [self.menu objectAtIndex:row];
            label.text = theItem.name;
        }           
        
    }else if (pickerView == self.iceAndSweetnessPicker) {
        
        if (component == iceComponent) {
            if ([self hasSelectableIce]) {
//                NSLog(@"%@", self.selectedMenuItem.iceLevels);
                label.text = [self.selectedMenuItem.localizedIceLevels objectAtIndex:row];
            }
        }
        else if (component == sweetnessComponent) {
            if ([self hasSelectableSweetness]) {
//                NSLog(@"%@", self.selectedMenuItem.sweetnessLevels);
                label.text = [self.selectedMenuItem.localizedSweetnessLevels objectAtIndex:row];
            }
        } 
        
    }else if (pickerView == self.sizeAndQuantityPicker) {
        
        if (component == sizeComponent) {
            
            if ([self hasSelectableSize]) {
//                NSLog(@"%@", self.selectedMenuItem.sizeLevels);
                NSString *theSize = [self.selectedMenuItem.sizeLevels objectAtIndex:row];
                NSNumber *thePrice = [self.selectedMenuItem priceForSize:theSize];                
                label.text = [NSString stringWithFormat:@"%@ %@", [BKMenuItem localizedStringForSize:theSize], [self currencyStringForPrice:thePrice]];
            }
        }
        else if (component == quantityComponent) {
            NSNumber *theNumber = [self.quantityLevels objectAtIndex:row];
            label.text = [theNumber stringValue];
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

#pragma mark - Update methods

- (void)updateSelectedMenuItemWithRow:(NSInteger)row {
    if (self.menu.count > 0) {
        BKMenuItem *theItem = [self.menu objectAtIndex:row];
        if (theItem != self.selectedMenuItem) {
            self.selectedMenuItem = theItem;
            self.selectedItemName = theItem.name;
            
            [self.iceAndSweetnessPicker reloadAllComponents];
            [self.sizeAndQuantityPicker reloadAllComponents];
            
            if (![self hasSelectableIce] && ![self hasSelectableSweetness]) {
//                NSLog(@"1");
                self.selectedIceLevel = nil;
                [self.iceAndSweetnessButton setEnabled:NO];
                [self changeButtonTitleButton:self.iceAndSweetnessButton title:noSelectableItem];
            }
            else {
//                NSLog(@"2");
                [self.iceAndSweetnessButton setEnabled:YES];
                
                [self.iceAndSweetnessPicker selectRow:0 inComponent:iceComponent animated:NO];
                [self pickerView:self.iceAndSweetnessPicker didSelectRow:0 inComponent:iceComponent];
                
                [self.iceAndSweetnessPicker selectRow:0 inComponent:sweetnessComponent animated:NO];
                [self pickerView:self.iceAndSweetnessPicker didSelectRow:0 inComponent:sweetnessComponent];
            }
//            if (theItem.sweetnessLevels.count == 0) {
////                NSLog(@"3");
//                self.selectedSweetness = nil;
//                [self.sizeAndQuantityButton setEnabled:NO];
//                [self changeButtonTitleButton:self.sizeAndQuantityButton title:noSelectableItem];
//            }
//            else {
////                NSLog(@"4");
//                [self.sizeAndQuantityButton setEnabled:YES];
//                [self.sizeAndQuantityPicker selectRow:0 inComponent:0 animated:NO];
//                [self pickerView:self.sizeAndQuantityPicker didSelectRow:0 inComponent:0];
//            }
            if ([self hasSelectableSize]) {
                [self.sizeAndQuantityPicker selectRow:0 inComponent:sizeComponent animated:NO];
                [self pickerView:self.sizeAndQuantityPicker didSelectRow:0 inComponent:sizeComponent];
            }
        }
    }
    else {
        [self.itemButton setEnabled:NO];
        [self changeButtonTitleButton:self.itemButton title:noSelectableItem];
        [self.iceAndSweetnessButton setEnabled:NO];
        [self changeButtonTitleButton:self.iceAndSweetnessButton title:noSelectableItem];
        [self.sizeAndQuantityButton setEnabled:NO];
        [self changeButtonTitleButton:self.sizeAndQuantityButton title:noSelectableItem];
    }
}

- (void)updateSelectedIceWithRow:(NSInteger)row {
    if ([self hasSelectableIce]) {
        self.selectedIceLevel = [self.selectedMenuItem.iceLevels objectAtIndex:row];
    }
}

- (void)updateSelectedSweetnessWithRow:(NSInteger)row {
    if ([self hasSelectableSweetness]) {
        self.selectedSweetness = [self.selectedMenuItem.sweetnessLevels objectAtIndex:row];
    }
}

- (void)updateSelectedQuantityWithRow:(NSInteger)row {
    NSNumber *theNumber = [self.quantityLevels objectAtIndex:row];
//    NSLog(@"theNumber stringValue = %@", [theNumber stringValue]);
    self.selectedQuantity = theNumber;
}

- (void)updateSelectedSizeWithRow:(NSInteger)row {
//    [self testPrint];
    if ([self hasSelectableSize]) {
        self.selectedSize = [self.selectedMenuItem.sizeLevels objectAtIndex:row];
    }
//    [self testPrint];
}

- (void)updateSelectedTimeWithDate:(NSDate *)date {
    self.selectedTime = date;
    [[BKOrderManager sharedBKOrderManager] setOrderTime:date];
}

#pragma mark - Modify order

- (void)addOrderContent {
//    [[BKOrderManager sharedBKOrderManager] addNewOrderContent:[BKTestCenter testOrderContent]];
    if ([self inValidSelectionCodes] == nil){
        [self testPrint];
        
        BKOrderContentForSending *newOrderContent = [[BKOrderContentForSending alloc] initWithMenu:self.selectedMenuItem
                                                                           ice:self.selectedIceLevel
                                                                     sweetness:self.selectedSweetness
                                                                      quantity:self.selectedQuantity
                                                                          size:self.selectedSize];
        
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
            NSLog(@"orderExistAlert.message :%@", self.orderExistAlert.message);
            [self.orderExistAlert setMessage:[self orderExistsMessage]];
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

#pragma mark - String for alert view

- (NSArray *)inValidSelectionCodes {
    NSMutableArray *result = [NSMutableArray array];
    
    if (self.selectedMenuItem == nil) {
//        NSLog(@"%@", [NSNumber numberWithInt:BKSelectionItemNotSelected]);
        [result addObject:[NSNumber numberWithInt:BKSelectionItemNotSelected]];
//        return BKSelectionItemNotSelected;
    }
    else {
        if ((self.selectedMenuItem.localizedIceLevels.count > 0) && (self.selectedIceLevel == nil)) {
//            NSLog(@"%@", [NSNumber numberWithInt:BKSelectionIceNotSelected]);
            [result addObject:[NSNumber numberWithInt:BKSelectionIceNotSelected]];
//            return BKSelectionIceNotSelected;
        }
        if ((self.selectedMenuItem.localizedSweetnessLevels.count > 0) && (self.selectedSweetness == nil)) {
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
    static NSString *itemNotSelected = @"尚未選擇商品";
    static NSString *iceNotSelected = @"尚未選擇冰量";
    static NSString *sweetnessNotSelected = @"尚未選擇糖量";
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

- (NSString *)orderExistsMessage {
    return [NSString stringWithFormat:@"有尚未發送的訂單\n商店名: %@\n%@", [[BKOrderManager sharedBKOrderManager] shopName], @"要把訂單刪除嗎?"];
}

#pragma mark - Button title update

- (void)changeButtonTitleButton:(UIButton *)button title:(NSString *)title {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateHighlighted];
} 

- (void)updateIceAndSweetnessButtonTitle {
    NSMutableArray *result = [NSMutableArray array];
    
    NSString *ice = [BKMenuItem localizedStringForIce:self.selectedIceLevel];
    if (ice != nil) {
        [result addObject:ice];
    }
    NSString *sweetness = [BKMenuItem localizedStringForSweetness:self.selectedSweetness];
    if (sweetness != nil) {
        [result addObject:sweetness];
    }
    NSString *title = [result componentsJoinedByString:@" "];
    [self changeButtonTitleButton:self.iceAndSweetnessButton title:title];
}

- (void)updateSizeAndQuantityButtonTitle {
//    [self testPrint];
    NSString *title;
    if (self.selectedSize != nil) {
        title = [NSString stringWithFormat:@"%@ %@ %@", self.selectedQuantity, [BKMenuItem localizedStringForSize:self.selectedSize], [self currencyStringForPrice:[self.selectedMenuItem priceForSize:self.selectedSize]]];
    }
    else {
        title = [NSString stringWithFormat:@"%@", self.selectedQuantity];
    }
    
    [self changeButtonTitleButton:self.sizeAndQuantityButton title:title];
}

- (void)updateTimeButtonTitle {
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yy/M/d HH:mm"];
//        [formatter setDateStyle:NSDateFormatterShortStyle];
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        NSLog(@"formatter string: %@", formatter.dateFormat);
    }
    NSString *title = [formatter stringFromDate:self.selectedTime];
    [self changeButtonTitleButton:self.timeButton title:title];
}

#pragma mark - Utility methods

- (BOOL)hasSelectableIce {
//    NSLog(@"self.selectedMenuItem.iceLevels: %@", self.selectedMenuItem.iceLevels);
//    NSLog(@"self.selectedMenuItem.iceLevels class: %@", [self.selectedMenuItem.iceLevels class]);
//    return NO;
    return (self.selectedMenuItem != nil) && (self.selectedMenuItem.localizedIceLevels.count > 0);
}

- (BOOL)hasSelectableSweetness {
//    NSLog(@"self.selectedMenuItem.sweetnessLevels: %@", self.selectedMenuItem.sweetnessLevels);
//    NSLog(@"self.selectedMenuItem.sweetnessLevels class: %@", [self.selectedMenuItem.sweetnessLevels class]);
//    return NO;
    return (self.selectedMenuItem != nil) && (self.selectedMenuItem.localizedSweetnessLevels.count > 0);
}

- (BOOL)hasSelectableSize {
//    NSLog(@"self.selectedMenuItem.sizeLevels.count :%d", self.selectedMenuItem.sizeLevels.count);
    return (self.selectedMenuItem != nil) && (self.selectedMenuItem.sizeLevels.count > 0);
}

- (void)testPrint {
    for (BKMenuItem *item in self.menu) {
        NSLog(@"name of item is %@", item.name);
        NSLog(@"%@", item.UUID);
    }
    NSLog(@"selectedItemName: %@", self.selectedItemName);
    NSLog(@"selectedIce: %@", self.selectedIceLevel);
    NSLog(@"selectedSweetness: %@", self.selectedSweetness);
    NSLog(@"selectedQuantity: %@", self.selectedQuantity);
    NSLog(@"selectedSize: %@", self.selectedSize);
}

#pragma mark - BKNoteViewDelegate

- (void)confirmButtonPressed:(BKNoteViewController *)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
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
    note.delegate = self;
    note.note = [[BKOrderManager sharedBKOrderManager] noteForShopInfo:self.shopInfo];
    note.shopID = self.shopID;
    note.orderExistAlert = self.orderExistAlert;    
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

- (IBAction)selectIceAndSweetnessButtonPressed:(id)sender {
    NSInteger iceRow = [self.iceAndSweetnessPicker selectedRowInComponent:iceComponent];
    NSInteger sweetnessRow = [self.iceAndSweetnessPicker selectedRowInComponent:sweetnessComponent];
    [self updateSelectedIceWithRow:iceRow];
    [self updateSelectedSweetnessWithRow:sweetnessRow];
    [self.iceAndSweetnessButton becomeFirstResponder];
}

- (IBAction)selectSizeAndQuantityButtonPressed:(id)sender {
    NSInteger sizeRow = [self.sizeAndQuantityPicker selectedRowInComponent:sizeComponent];
    NSInteger quantityRow = [self.sizeAndQuantityPicker selectedRowInComponent:quantityComponent];
    [self updateSelectedSizeWithRow:sizeRow];
    [self updateSelectedQuantityWithRow:quantityRow];
    [self.sizeAndQuantityButton becomeFirstResponder];
}

- (IBAction)selectQuantityButtonPressed:(id)sender {
    NSInteger row = [self.quantityPicker selectedRowInComponent:0];
    [self updateSelectedQuantityWithRow:row];
    [self.quantityButton becomeFirstResponder];
}

- (IBAction)selectTimeButtonPressed:(id)sender {
    [self.timeButton becomeFirstResponder];
}

- (IBAction)timePickerValueChanged:(id)sender {
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterFullStyle];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
    }
    //NSLog(@"picker date: %@", [formatter stringFromDate:self.timePicker.date] );
    //NSLog(@"min date: %@", [formatter stringFromDate:self.timePicker.minimumDate]);
    //NSLog(@"max date: %@", [formatter stringFromDate:self.timePicker.maximumDate]);
    
    NSDate *oneSecondAfterPickerDate = [self.timePicker.date dateByAddingTimeInterval:1];
    if ([self.timePicker.date isEqualToDate:self.timePicker.minimumDate]) {
        //NSLog(@"date is at or below minimum");
        self.timePicker.date = oneSecondAfterPickerDate;        
        [self.timePicker setDate:self.timePicker.minimumDate animated:YES];
    }
    else if ([self.timePicker.date isEqualToDate:self.timePicker.maximumDate]) {
        //NSLog(@"date is at or above maximum");
        self.timePicker.date = oneSecondAfterPickerDate;
        [self.timePicker setDate:self.timePicker.maximumDate animated:YES];
    }    
    
    [self updateSelectedTimeWithDate:self.timePicker.date];
}
- (void)viewDidUnload {
    [self setMinDeliveryCostLabel:nil];
    [super viewDidUnload];
}
@end
