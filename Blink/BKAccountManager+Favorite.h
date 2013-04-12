//
//  BKAccountManager+Favorite.h
//  Blink
//
//  Created by 維平 廖 on 13/4/12.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKAccountManager.h"

@interface BKAccountManager (Favorite)

- (void)addUserFavoriteShopID:(NSString *)shopID completeHandler:(loadDataComplete)completeHandler;

@end
