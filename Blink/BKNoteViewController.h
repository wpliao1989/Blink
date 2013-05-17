//
//  BKNoteViewController.h
//  Blink
//
//  Created by Wei Ping on 13/2/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKNoteViewDelegate;

@interface BKNoteViewController : UIViewController

@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *shopID;

#warning Should use delegate method for showing alert
@property (strong, nonatomic) UIAlertView *orderExistAlert;

@property (nonatomic) BOOL noteIsEditable;

@property (weak, nonatomic) id<BKNoteViewDelegate> delegate;

@end

@protocol BKNoteViewDelegate <NSObject>

@required

- (void)confirmButtonPressed:(BKNoteViewController *)sender;
- (NSString *)orderExistsMessage;

@end
