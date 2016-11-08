//
//  CTypeViewController.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 14.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "CTypeViewController.h"

#import "Utils.h"

#import "CTypeTableViewCell.h"

#import "CContentViewController.h"


@interface CTypeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *menu;

@property (strong, nonatomic) NSMutableArray <NSString *> *titles;
@property (strong, nonatomic) NSMutableArray <UIImage *> *images;

@end


@implementation CTypeViewController

- (instancetype)initWithMenu:(NSArray *)menu {
    self = [super init];
    if (self) {
        _menu = menu;
        _titles = [[NSMutableArray alloc] init];
        _images = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i <= _menu.count - 1; i++) {
            [_titles addObject:_menu[i][@"type"]];
            [_images addObject:[UIImage imageNamed:_menu[i][@"image"]]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils registerStringNameTableViewCellClass:NSStringFromClass([CTypeTableViewCell class])
                                   forTableView:_tableView
                            withReuseIdentifier:kReuseIdentifierType];
    [self setTitle:@"Меню"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifierType
                                                               forIndexPath:indexPath];
    [cell setTitle:_titles[indexPath.row]];
    [cell setImage:_images[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CContentViewController *contentVC = [[CContentViewController alloc] initWithType:indexPath.row];
    UINavigationController *contentNC = [[UINavigationController alloc] initWithRootViewController:contentVC];
    [self.splitViewController showDetailViewController:contentNC
                                                sender:self];
}

@end