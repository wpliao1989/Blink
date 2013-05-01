//
//  BKScrollableViewController.h
//  
//
//  Created by 維平 廖 on 13/3/29.
//
//

#import <UIKit/UIKit.h>
#import "BKAPIError.h"

@class MBProgressHUD;

@interface BKScrollableViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) MBProgressHUD *HUD;

@property (strong, nonatomic) UIView *activeResponder;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (BOOL)isUsingOwnScrollview; // Return YES if default scorllview setting is not favorable, default is NO

@end

@protocol MBProgressHUDDelegate;

typedef void (^aBlock)(NSString *successMessage);
typedef void (^failBlock)(NSError *error);

@interface BKScrollableViewController (HUDview)<MBProgressHUDDelegate>

- (void)showHUDViewWithMessage:(NSString *)message;

// Sub classes should overwrite this method to provide a custom mechanism
// Call successBlock and failBlock for successful and unsuccessful event, respectively
- (void)dismissHUDSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock;

@end
