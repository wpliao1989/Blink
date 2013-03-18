//
//  BKNoteViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKNoteViewController.h"
#import "BKOrderManager.h"
#import "BKShopInfoManager.h"

@interface BKNoteViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UITextView *noteText;
@property (strong, nonatomic) BKShopInfo *shopInfo;
- (IBAction)saveButtonPressed:(id)sender;

@end

@implementation BKNoteViewController

@synthesize shopInfo = _shopInfo;

- (BKShopInfo *)shopInfo {
    return [[BKShopInfoManager sharedBKShopInfoManager] shopInfoForShopID:self.shopID];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSLog(@"123");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    NSLog(@"viewDidLoad");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.noteText.text = self.note;
    [self.background setImage:[[UIImage imageNamed:@"list_try"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 14, 67, 20)]];     
    
    NSLog(@"Parent view controller: %@", self.parentViewController);
    NSLog(@"Presenting view controller: %@", self.presentingViewController);
}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"note will appear");
}

- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"note will disappear");
    [self.noteText resignFirstResponder];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"%@", NSStringFromCGRect(keyboardFrame));
    
    CGPoint oldOrigin = self.view.frame.origin;
    CGSize oldSize = self.view.frame.size;
    CGFloat padding = 5.0f;
    
    CGRect newFrame = CGRectMake(oldOrigin.x, keyboardFrame.origin.y - self.view.frame.size.height - padding, oldSize.width, oldSize.height);
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = newFrame;
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification {
//    NSDictionary *info = notification.userInfo;
//    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"%@", NSStringFromCGRect(keyboardFrame));
}

- (void)saveButtonPressed:(id)sender {
    if ([[BKOrderManager sharedBKOrderManager] saveNote:self.noteText.text forShopInfo:self.shopInfo]) {
        [self.delegate confirmButtonPressed:self];
    }
    else {
        [self.orderExistAlert setMessage:[self.delegate orderExistsMessage]];
        [self.orderExistAlert show];
    }
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(confirmButtonPressed:)]) {
//        [[BKOrderManager sharedBKOrderManager] saveNote:self.noteText.text forShopInfo:self.shopInfo];
//        [self.delegate confirmButtonPressed:self];
//    }
}

@end
