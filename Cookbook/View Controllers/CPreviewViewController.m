//
//  CPreviewViewController.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 14.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "CPreviewViewController.h"


@interface CPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation CPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Наталья Зубарева"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end