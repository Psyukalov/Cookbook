//
//  ContentViewController.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 10.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "ContentViewController.h"


@interface ContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *recipes;

@property (weak, nonatomic) IBOutlet UITableView *tableViewRecipes;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackgroundPhoto;

@property (strong, nonatomic) NSArray *array;

@end


@implementation ContentViewController

#pragma mark - Life cycle

- (instancetype)initWithRecipes:(NSDictionary *)recipes {
    self = [super init];
    if (self) {
        _recipes = recipes;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self applySetup];
}

- (void)applySetup {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _array = _recipes[@"recipes"];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    return cell;
}

@end