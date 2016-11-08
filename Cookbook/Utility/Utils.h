//
//  Utils.h
//  Marafon
//
//  Created by Vladimir Psyukalov on 17.03.16.
//  Copyright © 2016 NataliaZubareva. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define RGBA(R, G, B, A) ([UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:A / 255.f])
#define RGB(R, G, B) ([UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:1.0])

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kMainURL (@"http://cookbook.doctorzubareva.ru/")


@interface Utils : NSObject

+ (void)applyTransparentLayerForViews:(NSArray <UIView *> *)views
                           withColors:(NSArray <UIColor *> *)colors
                         andOpacities:(NSArray *)opacities;

+ (void)applyCornerRadii:(NSArray *)cornerRadii
                forViews:(NSArray<UIView *> *)views;

+ (void)applyBorderWithSizes:(NSArray *)sizes
                  withColors:(NSArray <UIColor *> *)colors
                    forViews:(NSArray <UIView *> *)views;

+ (void)applyBlurEffect:(UIBlurEffectStyle)blurEffectStyle
               forViews:(NSArray <UIView *> *)views;

+ (void)applyGradientForView:(UIView *)view
                  withColors:(NSArray *)colors
                andLocations:(NSArray *)locations;

+ (void)applyNavigationBarDesignWithTranslucent:(BOOL)translucent
                            withBackgroundColor:(UIColor *)backgroundColor
                             withTextAttributes:(NSDictionary *)textAttributes;

+ (id)sharedUserDefaults;

+ (void)registerStringNameTableViewCellClass:(NSString *)stringName
                                forTableView:(UITableView *)tableView
                         withReuseIdentifier:(NSString *)reuseIdentifier;

+ (void)registerStringNameCollectionViewCellClass:(NSString *)stringName
                                forCollectionView:(UICollectionView *)collectionView
                              withReuseIdentifier:(NSString *)reuseIdentifier;

+ (NSNumber *)decimalFromString:(NSString *)string;

+ (NSString *)stringFromDecimal:(CGFloat)decimal;

+ (UIAlertController *)createAlertControllerWithStyleAlert:(UIAlertControllerStyle)styleAlert
                                                 withTitle:(NSString *)title
                                                  withText:(NSString *)text
                                            andButtonTitle:(NSString *)buttonTitle
                                                completion:(void (^)())completion;

+ (NSCalendar *)sharedCalendar;

+ (NSString *)stringFromDate:(NSDate *)date
              withDateFormat:(NSString *)dateFormat;

+ (NSDate *)dateFromDateTimeMYSQL:(NSString *)date;
+ (NSString *)dateTimeMYSQLFromDate:(NSDate *)date;
+ (NSDate *)dateFromDateTimeMYSQL:(NSString *)date
                       withFormat:(NSString *)format;

+ (CGFloat)percentFromMax:(CGFloat)max
               andCurrent:(CGFloat)current;

+ (CGFloat)funcitonMafflinForGender:(NSUInteger)gender
                             weight:(CGFloat)weight
                             growth:(CGFloat)growth
                           birthday:(NSDate *)birthday
                    andPhysActivity:(CGFloat)physActivity;

+ (void)dataFromURL:(NSURL *)url
         completion:(void (^)(NSData *, NSError *))completion;

+ (NSMutableArray *)arrayWithData:(NSData *)data
                         withPath:(NSString *)path
                      andValueKey:(NSString *)valueKey;

+ (NSMutableArray *)arrayWithData:(NSData *)data
                      andValueKey:(NSString *)valueKey;

+ (NSString *)stringWithData:(NSData *)data
                    withPath:(NSString *)path
                      andKey:(NSString *)key;

+ (NSString *)stringWithData:(NSData *)data
                     withKey:(NSString *)key;

+ (NSMutableArray <NSDictionary *> *)arrayDictionaryWithData:(NSData *)data
                                                    withPath:(NSString *)path
                                                      andKey:(NSString *)key;

+ (NSMutableArray <NSDictionary *> *)arrayDictionaryWithData:(NSData *)data
                                                     withKey:(NSString *)key;

@end