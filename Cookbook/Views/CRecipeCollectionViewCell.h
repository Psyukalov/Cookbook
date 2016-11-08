//
//  CRecipeCollectionViewCell.h
//  Cookbook
//
//  Created by Vladimir Psyukalov on 15.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import <UIKit/UIKit.h>

#define kReuseIdentifierRecipe (@"Recipe")


@interface CRecipeCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *imageURL;

@property (strong, nonatomic) NSString *title;

@end