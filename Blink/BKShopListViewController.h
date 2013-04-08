//
//  shopListViewController.h
//  Blink
//
//  Created by Wei Ping on 13/1/29.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface BKShopListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIActionSheetDelegate, MKMapViewDelegate/*, CLLocationManagerDelegate*/>

//@property (nonatomic) BKReloadMethod method;

@end
