//
//  BKScrollableViewController.h
//  
//
//  Created by 維平 廖 on 13/3/29.
//
//

#import <UIKit/UIKit.h>
#import "BKAPIError.h"

@protocol MBProgressHUDDelegate;

@interface BKScrollableViewController : UIViewController<UITextFieldDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) UIView *activeResponder;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

typedef void (^aBlock)();
typedef void (^failBlock)(NSError *error);

@interface BKScrollableViewController (SupportLogin)

- (void)beginLogin;

// Sub classes should overwrite this method to provide a custom login mechanism
// Call successBlock and failBlock for successful and unsuccessful login result, respectively
- (void)loginCustomMethodSuccessBlock:(aBlock)successBlock failBlock:(failBlock)failBlock;

@end
