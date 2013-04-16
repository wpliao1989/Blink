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

@interface BKMenuItem : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSArray *iceLevels;
@property (strong, nonatomic) NSArray *sweetnessLevels;
@property (strong, nonatomic) NSArray *sizeLevels;

@property (strong, nonatomic) NSArray *localizedIceLevels; // Use this for display
@property (strong, nonatomic) NSArray *localizedSweetnessLevels; // Use this for display
@property (strong, nonatomic) NSArray *localizedSizeLevels;

@property (strong, nonatomic) NSDictionary *price;

@property (strong, nonatomic) NSString *detail;

- (NSNumber *)priceForSize:(NSString *)size;

@end

@interface BKMenuItem (Lookup)

+ (NSString *)localizedStringForIce:(NSString *)ice;
+ (NSString *)localizedStringForSweetness:(NSString *)sweetness;
+ (NSString *)localizedStringForSize:(NSString *)size;

+ (NSDictionary *)iceLookup;
+ (NSDictionary *)sweetnessLookup;
+ (NSDictionary *)sizeLookup;

@end
