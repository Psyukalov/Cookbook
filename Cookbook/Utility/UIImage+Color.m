//
//  UIImage+Color.m
//  Marathon
//
//  Created by Anton Yurichev on 02.12.15.
//  Copyright © 2015 Natalia Zubareva. All rights reserved.
//


#import "UIImage+Color.h"


@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color
                     height:(CGFloat)height {
    CGRect rect = CGRectMake(0.f, 0.f, 1.f, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end