//
//  CRecipes.h
//  Cookbook
//
//  Created by Vladimir Psyukalov on 05.08.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CRecipes : NSObject

@property (assign, nonatomic) NSUInteger identifier;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *ingredients;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *imageURL;

@property (assign, nonatomic) BOOL isFavorite;

@end
