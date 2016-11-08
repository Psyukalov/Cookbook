//
//  CTypeTableViewCell.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 14.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "CTypeTableViewCell.h"

#import "Utils.h"


@interface CTypeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewType;

@property (weak, nonatomic) IBOutlet UILabel *labelType;

@end


@implementation CTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = selected ? RGB(212.f, 112.f, 192.f) : RGB(152.f, 72.f, 132.f);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_labelType setText:_title];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [_imageViewType setImage:_image];
}

@end