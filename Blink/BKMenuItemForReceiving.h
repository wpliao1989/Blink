//
//  BKMenuItem.h
//  Blink
//
//  Created by Wei Ping on 13/2/22.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKMenuUUID;

#import "BKMenuItem.h"

@interface BKMenuItemForReceiving : BKMenuItem

- (id)initWithData:(NSDictionary *)data;

//@property (strong, nonatomic) NSNumber *UUID;
@property (strong, nonatomic, readonly) NSString *UUID;
@property (strong, nonatomic) NSArray *localizedIceLevels; // Use this for display
@property (strong, nonatomic) NSArray *localizedSweetnessLevels; // Use this for display
@property (strong, nonatomic) NSArray *localizedSizeLevels;
@property (strong, nonatomic, readonly) NSArray *priceLevels;
@property (strong, nonatomic, readonly) NSURL *picURL;
@property (weak, nonatomic) UIImage *picImage;

@end
