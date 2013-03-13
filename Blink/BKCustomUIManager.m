//
//  BKCustomUIManager.m
//  Blink
//
//  Created by Wei Ping on 13/3/12.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKCustomUIManager.h"
#import "BKCustomUIViewController.h"
#import "AppDelegate.h"

@interface BKCustomUIManager()

@property (strong, nonatomic) BKCustomUIViewController *customUIVC;

@end

@implementation BKCustomUIManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(BKCustomUIManager)

@synthesize backButton = _backButton;
@synthesize homeButton = _homeButton;

- (id)init
{
    self = [super init];
    if (self) {
        self.customUIVC = [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"customUIVC"];
        NSLog(@"customUIVC = %@", self.customUIVC);
    }
    return self;
}

- (UIBarButtonItem *)backButton {
    return self.customUIVC.backButton;
}

- (UIBarButtonItem *)homeButton {
    return self.customUIVC.homeButton;
}

@end
