//
//  BKModifyUserInfoViewController.h
//  Blink
//
//  Created by 維平 廖 on 13/5/17.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKModifyUserInfoViewControllerDelegate;

@interface BKModifyUserInfoViewController : UIViewController

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *userAddress;

@property (weak, nonatomic) id<BKModifyUserInfoViewControllerDelegate> delegate;

@end

@protocol BKModifyUserInfoViewControllerDelegate <NSObject>

- (void)modifyUserInfoVC:(BKModifyUserInfoViewController *)sender didFinishedModificationSavingInfo:(BOOL)savesInfo;

@end
