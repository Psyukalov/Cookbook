//
//  Utils.m
//  Marafon
//
//  Created by Vladimir Psyukalov on 17.03.16.
//  Copyright © 2016 NataliaZubareva. All rights reserved.
//


#import "Utils.h"

#import "UIImage+Color.h"


@implementation Utils

#pragma mark - Design

+ (void)applyTransparentLayerForViews:(NSArray<UIView *> *)views
                           withColors:(NSArray<UIColor *> *)colors
                         andOpacities:(NSArray *)opacities{
    for (int i = 0; i <= views.count - 1; i++) {
        CALayer *transparentLayer = [CALayer layer];
        transparentLayer.frame = views[i].bounds;
        transparentLayer.backgroundColor = [colors[i] CGColor];
        transparentLayer.opacity = [opacities[i] floatValue];
        [views[i].layer addSublayer:transparentLayer];
    }
}

+ (void)applyCornerRadii:(NSArray *)cornerRadii
                forViews:(NSArray<UIView *> *)views {
    for (int i = 0; i <= views.count - 1; i++) {
        views[i].layer.cornerRadius = [cornerRadii[i] floatValue];
        views[i].clipsToBounds = YES;
    }
}

+ (void)applyBorderWithSizes:(NSArray *)sizes
                  withColors:(NSArray <UIColor *> *)colors
                    forViews:(NSArray <UIView *> *)views {
    for (int i = 0; i <= views.count - 1; i++) {
        [views[i].layer setBorderWidth:[sizes[i] floatValue]];
        [views[i].layer setBorderColor:colors[i].CGColor];
    }
}

+ (void)applyBlurEffect:(UIBlurEffectStyle)blurEffectStyle
               forViews:(NSArray <UIView *> *)views {
    for (UIView *view in views) {
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            view.backgroundColor = [UIColor clearColor];
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            [visualEffectView setFrame:view.bounds];
            visualEffectView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            [view addSubview:visualEffectView];
        }
    }
}

+ (void)applyGradientForView:(UIView *)view
                  withColors:(NSArray *)colors
                andLocations:(NSArray *)locations {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGRect frame = view.layer.bounds;
    frame.size.width = SCREEN_WIDTH;
    gradientLayer.frame = frame;
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.cornerRadius = view.layer.cornerRadius;
    [view.layer addSublayer:gradientLayer];
}

+ (void)applyNavigationBarDesignWithTranslucent:(BOOL)translucent
                            withBackgroundColor:(UIColor *)backgroundColor
                             withTextAttributes:(NSDictionary *)textAttributes {
    [[UINavigationBar appearance] setTranslucent:translucent];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    UIImage *backgroundImage44pixels = [UIImage imageWithColor:backgroundColor
                                                        height:44.f];
    UIImage *backgroundImage64pixels = [UIImage imageWithColor:backgroundColor
                                                        height:64.f];
    [[UINavigationBar appearance] setBackgroundImage:backgroundImage44pixels
                                      forBarPosition:UIBarPositionTop
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:backgroundImage64pixels
                                      forBarPosition:UIBarPositionTopAttached
                                          barMetrics:UIBarMetricsDefault];
}

#pragma mark - NSUserDefaults

+ (id)sharedUserDefaults {
    static NSUserDefaults *userDafealts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDafealts = [NSUserDefaults standardUserDefaults];
    });
    return userDafealts;
}

#pragma mark - Register cell

+ (void)registerStringNameTableViewCellClass:(NSString *)stringName
                                forTableView:(UITableView *)tableView
                         withReuseIdentifier:(NSString *)reuseIdentifier {
    [tableView registerNib:[UINib nibWithNibName:stringName
                                          bundle:nil]
    forCellReuseIdentifier:reuseIdentifier];
}

+ (void)registerStringNameCollectionViewCellClass:(NSString *)stringName
                                forCollectionView:(UICollectionView *)collectionView
                              withReuseIdentifier:(NSString *)reuseIdentifier {
    [collectionView registerNib:[UINib nibWithNibName:stringName
                                               bundle:nil]
     forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - Converting

+ (NSNumber *)decimalFromString:(NSString *)string {
    NSNumber *result;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMinimumFractionDigits:1];
    result = [numberFormatter numberFromString:string];
    return result;
}

+ (NSString *)stringFromDecimal:(CGFloat)decimal {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:1];
    NSString *result = [NSString stringWithString:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:decimal]]];
    return result;
}

#pragma mark - UIAlertController

+ (UIAlertController *)createAlertControllerWithStyleAlert:(UIAlertControllerStyle)styleAlert
                                                 withTitle:(NSString *)title
                                                  withText:(NSString *)text
                                            andButtonTitle:(NSString *)buttonTitle
                                                completion:(void (^)())completion {
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:title
                                                          message:text
                                                   preferredStyle:styleAlert];
    if (buttonTitle) {
        UIAlertAction *alertAction;
        alertAction = [UIAlertAction actionWithTitle:buttonTitle
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 if (completion) {
                                                     completion();
                                                 }
                                             }];
        [alertController addAction:alertAction];
    }
    return alertController;
}

#pragma mark - Date utils

+ (NSCalendar *)sharedCalendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

+ (NSDateFormatter *)sharedDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale =[NSLocale currentLocale];
        dateFormatter.locale = locale;
    });
    return dateFormatter;
}

+ (NSString *)stringFromDate:(NSDate *)date
              withDateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [self sharedDateFormatter];
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:date];
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [self sharedDateFormatter];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:format];
    return formatter;
}

+ (NSDate *)dateFromDateTimeMYSQL:(NSString *)date {
    return [[self dateFormatterWithFormat:@"yyyy-MM-dd"] dateFromString:date];
}

+ (NSString *)dateTimeMYSQLFromDate:(NSDate *)date {
    return [[self dateFormatterWithFormat:@"yyyy-MM-dd"] stringFromDate:date];
}

+ (NSDate *)dateFromDateTimeMYSQL:(NSString *)date
                       withFormat:(NSString *)format {
    return [[self dateFormatterWithFormat:format] dateFromString:date];
}

#pragma mark - Mathf

+ (CGFloat)percentFromMax:(CGFloat)max
               andCurrent:(CGFloat)current {
    return current / max;
}

+ (CGFloat)funcitonMafflinForGender:(NSUInteger)gender
                             weight:(CGFloat)weight
                             growth:(CGFloat)growth
                           birthday:(NSDate *)birthday
                    andPhysActivity:(CGFloat)physActivity{
    NSCalendar *calendar = [self sharedCalendar];
    NSDateComponents *year = [calendar components:NSCalendarUnitYear
                                         fromDate:birthday
                                           toDate:[NSDate date]
                                          options:0];
    CGFloat kParam1 = 9.99f;
    CGFloat kParam2 = 6.25f;
    CGFloat kParam3 = 4.92f;
    NSUInteger age = [year year];
    CGFloat kGender;
    if (gender == 1) {
        kGender = 5;
    } else if (gender == 0) {
        kGender = -161;
    }
    CGFloat res;
    CGFloat valuePrimaryMetabolism = kParam1 * weight + kParam2 * growth - kParam3 * age + kGender;
    res = (valuePrimaryMetabolism + 0.1f * valuePrimaryMetabolism) * physActivity;
    res -= res * 0.2f;
    return res;
}

#pragma mark - NSURLConnection

+ (void)dataFromURL:(NSURL *)url
         completion:(void (^)(NSData *, NSError *))completion {
    NSURLSession *URLSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [URLSession dataTaskWithURL:url
                                                      completionHandler:^(NSData *data,
                                                                          NSURLResponse *response,
                                                                          NSError *error) {
                                                          completion(data, error);
                                                      }];
    [sessionDataTask resume];
}

+ (NSMutableArray *)arrayWithData:(NSData *)data
                         withPath:(NSString *)path
                      andValueKey:(NSString *)valueKey {
    NSError *error;
    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableLeaves
                                                                error:&error];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (!error) {
        if (path) {
            dictionary = dictionary[path];
        }
        for (NSDictionary *tempDictionary in dictionary) {
            [result addObject:[tempDictionary valueForKey:valueKey]];
        }
    }
    return result;
}

+ (NSMutableArray *)arrayWithData:(NSData *)data
                      andValueKey:(NSString *)valueKey {
    return [self arrayWithData:data
                      withPath:nil
                   andValueKey:valueKey];
}

+ (NSString *)stringWithData:(NSData *)data
                    withPath:(NSString *)path
                      andKey:(NSString *)key {
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:&error];
    NSString *result;
    if (!error) {
        if (path) {
            dictionary = dictionary[path];
        }
        result = [dictionary objectForKey:key];
    }
    return result;
}

+ (NSString *)stringWithData:(NSData *)data
                     withKey:(NSString *)key {
    return [self stringWithData:data
                       withPath:nil
                         andKey:key];
}

+ (NSMutableArray<NSDictionary *> *)arrayDictionaryWithData:(NSData *)data
                                                   withPath:(NSString *)path
                                                     andKey:(NSString *)key {
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:&error];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (!error) {
        if (path) {
            dictionary = dictionary[path];
        }
        NSArray *array = [dictionary valueForKeyPath:key];
        for (NSDictionary *tempDictionary in array) {
            [result addObject:tempDictionary];
        }
    }
    return result;
}

+ (NSMutableArray <NSDictionary *> *)arrayDictionaryWithData:(NSData *)data
                                                     withKey:(NSString *)key {
    return [self arrayDictionaryWithData:data
                                withPath:nil
                                  andKey:key];
}

@end