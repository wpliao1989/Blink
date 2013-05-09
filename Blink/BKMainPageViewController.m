//
//  mainPageViewController.m
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMainPageViewController.h"
#import "BKAccountManager.h"
#import "AKSegmentedControl.h"
#import "BKItemSelectButton.h"
#import "AKSegmentedControl+SelectedIndex.h"
#import "BKAPIManager.h"
#import "UIButton+AKSegmentedButton.h"
#import "UIButton+ChangeTitle.h"
#import "BKSearchParameter.h"
#import "BKShopListViewController.h"
#import "UIViewController+SharedCustomizedUI.h"

@interface BKMainPageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *userToolButton;

@property (strong, nonatomic) AKSegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *districtPicker;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *cityButton;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *districtButton;

//@property (strong, nonatomic) IBOutlet UIImageView *backgound;

// Picker related
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSArray *districts;
@property (strong, nonatomic) NSString *selectedCity;
@property (strong, nonatomic) NSString *selectedDistrict;
- (void)updateSelectedCityWithRow:(NSInteger)row;
- (void)updateSelectedDistrictWithRow:(NSInteger)row;
- (BOOL)hasSelectableCity;
- (BOOL)hasSelectableDistrict;
//- (void)changeButtonTitleButton:(UIButton *)button title:(NSString *)title;

- (IBAction)searchShopButtonPressed:(id)sender;
- (IBAction)searchFoodButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)userToolButtonPressed:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)selectCityButtonPressed:(id)sender;
- (IBAction)selectDistrictButtonPressed:(id)sender;
- (IBAction)selectRoadButtonPressed:(id)sender;

- (void)setUpSegmentedControl;
- (void)setUpPickers;

// --------------Followings are deprecated--------------
@property (strong, nonatomic) IBOutlet UITextField *countyTextField;
@property (strong, nonatomic) IBOutlet UITextField *regionTextField;
@property (strong, nonatomic) IBOutlet UITextField *roadTextField;
@property (strong, nonatomic) UITextField *activeField;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet BKItemSelectButton *roadButton;

@end

@implementation BKMainPageViewController

#pragma mark Getters and Setters

- (NSArray *)cities {
    return [BKAPIManager sharedBKAPIManager].cities;
}

- (NSArray *)districts {
    return [[BKAPIManager sharedBKAPIManager] regionsForCity:self.selectedCity];
}

- (void)setSelectedCity:(NSString *)selectedCity {
    _selectedCity = selectedCity;
//    [self changeButtonTitleButton:self.countyButton title:selectedCounty];
    [self.cityButton changeTitleTo:selectedCity];
}

- (void)setSelectedDistrict:(NSString *)selectedDistrict {
    _selectedDistrict = selectedDistrict;
//    [self changeButtonTitleButton:self.regionButton title:selectedRegion];
    [self.districtButton changeTitleTo:selectedDistrict];
}

#pragma mark View controller life cycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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
//    [self.homeButton setBackgroundImage:[[UIImage imageNamed:@"37x-Checkmark.png"] resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    UIImage *image = [UIImage imageNamed:@"a2.png"];

//    self.segmentedControl.segmentedControlStyle = 5;

//    [self.segmentedControl setImage:image forSegmentAtIndex:0];
//    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:nil]];
    [self setUpPickers];
    [self setUpSegmentedControl];
    [self.titleBackground setImage:[self titleImage]];
    
    // Register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverInfoDidUpdate) name:kBKServerInfoDidUpdateNotification object:nil];
}

#pragma mark - Utility methods

- (void)setUpPickers {
    if ([BKAPIManager sharedBKAPIManager].loadingServerInfo) {
        self.cityButton.enabled = NO;
        self.districtButton.enabled = NO;
    }
    self.cityButton.inputView = self.cityPicker;
    NSLog(@"pickers:%@  %@", self.cityPicker, self.districtPicker);
    self.districtButton.inputView = self.districtPicker;
    [self initPickerSelect];    
//    self.roadButton.inputView = self.countyPicker;
}

- (void)initPickerSelect {
    [self updateSelectedCityWithRow:0];
    [self updateSelectedDistrictWithRow:0];
    
//    if ([self hasSelectableCounty]) {
//        [self.countyButton setEnabled:YES];
//        [self updateSelectedCountyWithRow:0];
//    }
//    else {
//        [self.countyButton setEnabled:NO];
//    }
//    
//    if ([self hasSelectableRegion]) {
//        [self.regionButton setEnabled:YES];
//        [self updateSelectedRegionWithRow:0];
//    }
//    else {
//        [self.regionButton setEnabled:NO];
//    }
    
}

- (void)setUpSegmentedControl
{
    self.segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(20.0, 115.0, 278.0, 32.0)];
    [self.segmentedControl addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [self.segmentedControl setSelectedIndex:0];     
    
    [self.segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    //    [self.segmentedControl1 setSeparatorImage:[UIImage imageNhCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
        
        
    
    //    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed-right.png"]
    //                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    // Button 1
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"a2.png"];
    UIImage *leftButtonPressedImage = [UIImage imageNamed:@"a2_press"];
    UIButton *leftButton = [UIButton buttonForNormalImage:leftButtonImage pressedImage:leftButtonPressedImage];
    
    // Button 2    
    UIImage *rightButtonImage = [UIImage imageNamed:@"a3.png"];
    UIImage *rightButtonPressedImage = [UIImage imageNamed:@"a3_press"];
    UIButton *rightButton = [UIButton buttonForNormalImage:rightButtonImage pressedImage:rightButtonPressedImage];
    
    [self.segmentedControl setButtonsArray:@[leftButton, rightButton]];
    [self.scrollView addSubview:self.segmentedControl];
}

#pragma mark - Picker dataSource, delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {    
    NSInteger count = 1;
    if (pickerView == self.cityPicker) {
        if ([self hasSelectableCity]) {
            count = self.cities.count;
        }
    }
    else if (pickerView == self.districtPicker) {
        if ([self hasSelectableDistrict]) {
            count = self.districts.count;
        }
    }
    return count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = NSLocalizedString(@"No item", @"無可選擇項目");
    
    if (pickerView == self.cityPicker) {
        if ([self hasSelectableCity]) {
            label.text = [self.cities objectAtIndex:row];
        }        
    }
    else if (pickerView == self.districtPicker) {
        if ([self hasSelectableDistrict]) {
            label.text = [self.districts objectAtIndex:row];
        }
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.cityPicker) {
        [self updateSelectedCityWithRow:row];
    }
    else if (pickerView == self.districtPicker) {
        [self updateSelectedDistrictWithRow:row];
    }
}

# pragma mark - Check if selectable

- (BOOL)hasSelectableCity {
    return self.cities.count > 0;
}

- (BOOL)hasSelectableDistrict {
    return self.districts.count > 0;
}

#pragma mark - Update selected item methods

- (void)updateSelectedCityWithRow:(NSInteger)row {
    if ([self hasSelectableCity]) {
        self.selectedCity = [self.cities objectAtIndex:row];
        
        [self.districtPicker reloadAllComponents];
        [self.districtPicker selectRow:0 inComponent:0 animated:NO];
        [self pickerView:self.districtPicker didSelectRow:0 inComponent:0];
    }    
}

- (void)updateSelectedDistrictWithRow:(NSInteger)row {
    if ([self hasSelectableDistrict]) {
        self.selectedDistrict = [self.districts objectAtIndex:row];
    }
}

//#pragma mark - Button title update
//
//- (void)changeButtonTitleButton:(UIButton *)button title:(NSString *)title {
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitle:title forState:UIControlStateSelected];
//    [button setTitle:title forState:UIControlStateHighlighted];
//}

#pragma mark - Server info notification

- (void)serverInfoDidUpdate {
    NSLog(@"server info did update!");
    self.cityButton.enabled = YES;
    self.districtButton.enabled = YES;
    [self.cityPicker reloadAllComponents];
    [self.districtPicker reloadAllComponents];
    [self initPickerSelect];
}

#pragma mark - Text field event
// Deprecated
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"begin editing!");
    self.activeField = textField;
}
// Deprecated
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}
// Deprecated
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Segment control event

- (void)segmentedViewController:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    
    if (segmentedControl == self.segmentedControl)
        NSLog(@"SegmentedControl #1 : Selected Index %d", [segmentedControl firstSelectedIndex]);
    
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"shopSearchSegue"]) {
        BKSearchParameter *searchParameter = [[BKSearchParameter alloc] init];
        searchParameter.city = self.selectedCity;
        searchParameter.district = self.selectedDistrict;
        
        NSInteger deliveryIndex = 0;
        NSInteger takeoutIndex = 1;
        if ([self.segmentedControl firstSelectedIndex] == deliveryIndex) {
            searchParameter.method = kBKOrderMethodDelivery;
        }
        else if ([self.segmentedControl firstSelectedIndex] == takeoutIndex) {
            searchParameter.method = kBKOrderMethodTakeout;
        }
        else {
            NSLog(@"Warning: invalid segmented control index!");
        }
        NSLog(@"search parameter = %@", searchParameter);
        BKShopListViewController *shopListVC = segue.destinationViewController;
        shopListVC.searchParameter = searchParameter;
    }
}

#pragma mark - IBAction

- (IBAction)searchShopButtonPressed:(id)sender {
    NSLog(@"Selected city: %@", self.selectedCity);
    NSLog(@"Selected region: %@", self.selectedDistrict);
    if ((self.selectedCity != nil)&&(self.selectedDistrict != nil)) {
        [self performSegueWithIdentifier:@"shopSearchSegue" sender:sender];
    }
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

- (IBAction)selectCityButtonPressed:(id)sender {
    self.activeResponder = sender;
    [sender becomeFirstResponder];
}

- (IBAction)selectDistrictButtonPressed:(id)sender {
    self.activeResponder = sender;
    [sender becomeFirstResponder];
}

- (IBAction)selectRoadButtonPressed:(id)sender {
    self.activeResponder = sender;
    [sender becomeFirstResponder];
}

@end
