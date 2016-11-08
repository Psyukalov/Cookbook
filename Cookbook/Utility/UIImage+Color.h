//
//  UIImage+Color.h
//  Marathon
//
//  Created by Anton Yurichev on 02.12.15.
//  Copyright © 2015 Natalia Zubareva. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color
                     height:(CGFloat)height;

@end