//
//  BKMenuItem.h
//  
//
//  Created by 維平 廖 on 13/4/16.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kBKMenuName;
FOUNDATION_EXPORT NSString *const kBKMenuPrice;
FOUNDATION_EXPORT NSString *const kBKMenuIce;
FOUNDATION_EXPORT NSString *const kBKMenuSweetness;
FOUNDATION_EXPORT NSString *const kBKMenuDetail;

FOUNDATION_EXPORT NSString *const kBKMenuPriceMedium;
FOUNDATION_EXPORT NSString *const kBKMenuPriceLarge;
FOUNDATION_EXPORT NSString *const kBKMenuPriceSmall;

@interface BKMenuItem : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSArray *iceLevels;
@property (strong, nonatomic) NSArray *sweetnessLevels;
@property (strong, nonatomic) NSArray *sizeLevels;

@property (strong, nonatomic) NSDictionary *price;

@property (strong, nonatomic) NSString *detail;

- (NSNumber *)priceForSize:(NSString *)size;
+ (id)menuItemForMenuItem:(BKMenuItem *)item;

@end

@interface BKMenuItem (Lookup)

+ (NSString *)localizedStringForIce:(NSString *)ice;
+ (NSString *)localizedStringForSweetness:(NSString *)sweetness;
+ (NSString *)localizedStringForSize:(NSString *)size;

+ (NSDictionary *)iceLookup;
+ (NSDictionary *)sweetnessLookup;
+ (NSDictionary *)sizeLookup;

+ (NSArray *)orderedArrayOfIce;
+ (NSArray *)orderedArrayOfSweetness;
+ (NSArray *)orderedArrayOfLocalizedIce;
+ (NSArray *)orderedArrayOfLocalizedSweetness;

@end
