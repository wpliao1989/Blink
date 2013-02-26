//
//  BKItemSelectButton.m
//  Blink
//
//  Created by Wei Ping on 13/2/25.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKItemSelectButton.h"

@implementation BKItemSelectButton

@synthesize inputView = _inputView;
@synthesize inputAccessoryView = _inputAccessoryView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView *)inputAccessoryView {
//    static UIToolbar *inputAccessoryView;
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[UIToolbar alloc] init];
        _inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
        _inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_inputAccessoryView sizeToFit];
        CGRect frame = _inputAccessoryView.frame;
        frame.size.height = 36;
        _inputAccessoryView.frame = frame;
//        NSLog(@"%@", NSStringFromCGRect(frame));
        
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
        [_inputAccessoryView setItems:array];
    }
    return _inputAccessoryView;
	
}

- (void)done:(id)sender {
//    NSLog(@"%@", sender);
//    NSLog(@"self.text :%@", self.currentTitle);
    [self resignFirstResponder];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)becomeFirstResponder{
//    NSLog(@"becomeFirstResponder");
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
//    NSLog(@"resignFirstResponder");
    return [super resignFirstResponder];
}

@end
