//
//  BKCustomUIManager.h
//  Blink
//
//  Created by Wei Ping on 13/3/12.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWLSynthesizeSingleton.h"

@interface BKCustomUIManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(BKCustomUIManager)

@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *homeButton;

@end
