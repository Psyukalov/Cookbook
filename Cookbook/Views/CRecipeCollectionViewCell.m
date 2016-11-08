//
//  CRecipeCollectionViewCell.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 15.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "CRecipeCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "Utils.h"


@interface CRecipeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end


@implementation CRecipeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utils applyCornerRadii:@[@10.f]
                   forViews:@[self]];
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self checkImage];
}

- (void)loadImage {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageURL]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             [_imageView setImage:image];
                             [[SDImageCache sharedImageCache] storeImage:image
                                                                  forKey:_imageURL];
                         }];
}

- (void)checkImage {
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:_imageURL
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (!image) {
                                                             NSLog(@"Load, cache and set image: %@", _imageURL);
                                                             [self loadImage];
                                                         } else {
                                                             NSLog(@"Set image: %@", _imageURL);
                                                             [_imageView setImage:image];
                                                         }
                                                     }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_labelTitle setText:_title];
}

@end