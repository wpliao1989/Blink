//
//  BKScrollableViewController.h
//  
//
//  Created by 維平 廖 on 13/3/29.
//
//

#import <UIKit/UIKit.h>

@interface BKScrollableViewController : UIViewController

@property (strong, nonatomic) UIView *activeResponder;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
