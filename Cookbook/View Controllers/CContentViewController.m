//
//  CContentViewController.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 14.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "CContentViewController.h"

#import "Utils.h"

#import "CRecipeViewController.h"

#import "CRecipeCollectionViewCell.h"

#import <AFNetworking/AFNetworking.h>

#import "CRecipes.h"


#define kCount (2)

#define kSpacing (10.f)

#define kCellWidth (240.f)
#define kCellHeight (200.f)

#define kCountOfNextItems (20)

#define kDistanceToBottom (10.f)


@interface CContentViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray <CRecipes *> *recipes;

@property (assign, nonatomic) NSUInteger type;
@property (assign, nonatomic) NSUInteger count;

@property (assign, nonatomic) CGFloat width;

@property (strong, nonatomic) UIBarButtonItem *menuBBI;

@property (assign, nonatomic) NSUInteger loadedItems;

@property (assign, nonatomic) BOOL isBottom;

@end


@implementation CContentViewController

- (instancetype)initWithType:(NSUInteger)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [Utils registerStringNameCollectionViewCellClass:NSStringFromClass([CRecipeCollectionViewCell class])
                                   forCollectionView:_collectionView
                                 withReuseIdentifier:kReuseIdentifierRecipe];
    _recipes = [[NSMutableArray alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(refreshControl_VC)
              forControlEvents:UIControlEventValueChanged];
    [_collectionView addSubview:_refreshControl];
    [_activityIndicator startAnimating];
    [_labelDescription setText:nil];
    _isBottom = NO;
    [_collectionView setAlwaysBounceVertical:YES];
    if (_type != 4) {
        [self clearAndLoad];
        [self setTitle:@"Рецепты"];
    } else {
        [self setTitle:@"Избранное"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_collectionView performBatchUpdates:nil
                              completion:nil];
}

- (void)clearAndLoad {
    [_recipes removeAllObjects];
    _loadedItems = 0;
    [self loadDataFrom:0
                    to:kCountOfNextItems];
}

- (void)loadDataFrom:(NSUInteger)from
                  to:(NSUInteger)to {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [manager POST:[NSString stringWithFormat:@"%@%@", kMainURL, @"select_recipes.php"]
       parameters:@{@"type" : @(_type),
                    @"from" : @(from),
                    @"to" : @(to)}
         progress:^(NSProgress * _Nonnull uploadProgress) {
             //
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self parseResponce:responseObject];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [_recipes removeAllObjects];
             [_collectionView reloadData];
             [_labelDescription setText:error.localizedDescription];
             [_refreshControl endRefreshing];
             [_activityIndicator stopAnimating];
         }];
}

- (void)parseResponce:(id)responce {
    NSDictionary *dictionary = responce;
    if ([dictionary[@"status"] integerValue] == 0) {
        [_labelDescription setText:@"Нет ответа от сервера."];
    } else {
        if (dictionary[@"answer"] != (id)[NSNull null]) {
            NSArray *array = dictionary[@"answer"];
            for (NSUInteger i = 0; i <= array.count - 1; i++) {
                CRecipes *recipe = [[CRecipes alloc] init];
                recipe.identifier = [array[i][@"id"] integerValue];
                recipe.title = array[i][@"title"];
                recipe.imageURL = array[i][@"imageURL"];
                [_recipes addObject:recipe];
            }
            NSLog(@"Count of items: %ld", (unsigned long) _recipes.count);
            _isBottom = NO;
            [_labelDescription setText:nil];
            [_collectionView reloadData];
        }
    }
    [_refreshControl endRefreshing];
    [_activityIndicator stopAnimating];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                                     [_collectionView performBatchUpdates:nil
                                                               completion:nil];
                                 }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll: (UIScrollView *)scroll {
    CGFloat currentOffset = scroll.contentOffset.y;
    CGFloat maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    if (maximumOffset - currentOffset <= kDistanceToBottom && !_isBottom) {
        _isBottom = YES;
        _loadedItems += kCountOfNextItems;
        [self loadDataFrom:_loadedItems
                        to:kCountOfNextItems];
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recipes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRecipeCollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifierRecipe
                                                     forIndexPath:indexPath];
    if (_recipes.count > 0) {
        [cell setTitle:_recipes[indexPath.row].title];
        [cell setImageURL:_recipes[indexPath.row].imageURL];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.frame.size.width - 2 * kSpacing;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        width = (self.view.frame.size.width - (kCount + 1) * kSpacing) / kCount;
    }
    return CGSizeMake(width, kCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_recipes.count > 0) {
        CRecipeViewController *recipeVC = [[CRecipeViewController alloc] initWithRecipeIdentifier:_recipes[indexPath.row].identifier];
        [self.navigationController pushViewController:recipeVC
                                             animated:YES];
    }
}

#pragma mark - Actions

- (void)refreshControl_VC {
    if ([_refreshControl isRefreshing]) {
        [self clearAndLoad];
    }
}

@end
