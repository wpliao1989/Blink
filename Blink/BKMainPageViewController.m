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

@interface AKSegmentedControl (SeletedIndex)

- (NSUInteger)firstSelectedIndex;

@end

@implementation AKSegmentedControl (SeletedIndex)

- (NSUInteger)firstSelectedIndex {
    return [self.selectedIndexes firstIndex];
}

@end

@interface BKMainPageViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *userToolButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITextField *countyTextField;
@property (strong, nonatomic) IBOutlet UITextField *regionTextField;
@property (strong, nonatomic) IBOutlet UITextField *roadTextField;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) AKSegmentedControl *segmentedControl;

- (IBAction)searchShopButtonPressed:(id)sender;
- (IBAction)searchFoodButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)userToolButtonPressed:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;

- (void)setUpSegmentedControl;

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
    [super viewWillAppear:animated];
    NSLog(@"%@", NSStringFromCGSize(self.view.frame.size));
    NSLog(@"%@", NSStringFromCGSize(self.navigationController.view.frame.size));
    CGSize sizeOfView = self.view.frame.size;
    self.scrollView.contentSize = sizeOfView;

    if ([BKAccountManager sharedBKAccountManager].isLogin == YES) {        
        self.navigationItem.rightBarButtonItem = self.userToolButton;
    }
    else {        
        self.navigationItem.rightBarButtonItem = self.loginButton;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self setUpSegmentedControl];
//    UITextView *test = [[UITextView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//    test.text = @"123123123\n1231\n123123";
//    NSLog(@"test height = %f", test.contentSize.height);
//    [self.scrollView addSubview:test];
//    NSLog(@"test height = %f", test.contentSize.height);
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
    UIButton *leftButton = [[UIButton alloc] init];
    UIImage *leftButtonImage = [UIImage imageNamed:@"a2.png"];
    UIImage *leftButtonPressedImage = [UIImage imageNamed:@"a2_press"];
    
    //    [buttonSocial setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    //    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton setImage:leftButtonPressedImage forState:UIControlStateSelected];
    [leftButton setImage:leftButtonPressedImage forState:UIControlStateHighlighted];
    [leftButton setImage:leftButtonPressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *rightButton = [[UIButton alloc] init];
    UIImage *rightButtonImage = [UIImage imageNamed:@"a3.png"];
    UIImage *rightButtonPressedImage = [UIImage imageNamed:@"a3_press"];
    
    //    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    //    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    //    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    [rightButton setImage:rightButtonPressedImage forState:UIControlStateSelected];
    [rightButton setImage:rightButtonPressedImage forState:UIControlStateHighlighted];
    [rightButton setImage:rightButtonPressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [self.segmentedControl setButtonsArray:@[leftButton, rightButton]];
    [self.scrollView addSubview:self.segmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoardDidShow:(NSNotification *)notification {    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
//    NSLog(@"view frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"aRect: %@", NSStringFromCGRect(aRect));
//    NSLog(@"scroll view frame: %@", NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"avtiveField frame: %@", NSStringFromCGRect(self.activeField.frame));
    
    if (!CGRectContainsRect(aRect, self.activeField.frame)) {
        CGPoint scrollPoint = CGPointMake(0, self.activeField.frame.origin.y + self.activeField.frame.size.height - aRect.size.height);
        NSLog(@"Scroll point: %@", NSStringFromCGPoint(scrollPoint));
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void)segmentedViewController:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    
    if (segmentedControl == self.segmentedControl)
        NSLog(@"SegmentedControl #1 : Selected Index %d", [segmentedControl firstSelectedIndex]);
    
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    NSTimeInterval animationTime = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationTime animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"begin editing!");
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    [self.activeField resignFirstResponder];
//}

- (IBAction)searchShopButtonPressed:(id)sender {
//    [self performSegueWithIdentifier:@"shopListSegue" sender:sender];
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

@end
