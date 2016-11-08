//
//  CTypeTableViewCell.h
//  Cookbook
//
//  Created by Vladimir Psyukalov on 14.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import <UIKit/UIKit.h>


#define kReuseIdentifierType (@"Type")


@interface CTypeTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) UIImage *image;

@end