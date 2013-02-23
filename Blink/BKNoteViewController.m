//
//  BKNoteViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKNoteViewController.h"
#import "BKOrderManager.h"

@interface BKNoteViewController ()

@property (strong, nonatomic) IBOutlet UITextView *noteText;

@end

@implementation BKNoteViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"note will appear");
}

- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"note will disappear");
    [self.noteText resignFirstResponder];
    [[BKOrderManager sharedBKOrderManager] saveNote:self.noteText.text];
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

@end
