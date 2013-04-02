//
//  BKScrollableViewController.h
//  
//
//  Created by 維平 廖 on 13/3/29.
//
//

#import <UIKit/UIKit.h>
#import "BKAPIError.h"

@interface BKScrollableViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) UIView *activeResponder;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@protocol MBProgressHUDDelegate;

typedef void (^aBlock)(NSString *successMessage);
typedef void (^failBlock)(NSError *error);

@interface BKScrollableViewController (HUDview)<MBProgressHUDDelegate>

- (void)showHUDViewWithMessage:(NSString *)message;

// Sub classes should overwrite this method to provide a custom mechanism
// Call successBlock and failBlock for successful and unsuccessful event, respectively
- (void)loginCustomMethodSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock;

@end