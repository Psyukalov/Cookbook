//
//  CRecipeViewController.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 16.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "CRecipeViewController.h"

#import "Utils.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import <AFNetworking/AFNetworking.h>

#import "CRecipes.h"


#define kMarginFromSuperview (10.f)
#define kMarginFromViewContent (10.f)


@interface CRecipeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIView *viewIndicator;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraint;

@property (strong, nonatomic) CRecipes *recipe;

@property (assign, nonatomic) NSUInteger identifier;

@end


@implementation CRecipeViewController

- (instancetype)initWithRecipeIdentifier:(NSUInteger)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:nil];
    [Utils applyCornerRadii:@[@10.f,
                              @10.f]
                   forViews:@[_viewContent,
                              _viewIndicator]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_activityIndicator startAnimating];
    _recipe = [[CRecipes alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                                     [self resizeTextView];
                                 }];
}

- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [manager POST:[NSString stringWithFormat:@"%@%@", kMainURL, @"select_recipe_info.php"]
       parameters:@{@"id" : @(_identifier)}
         progress:^(NSProgress * _Nonnull uploadProgress) {
             //
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self parseResponce:responseObject];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self stopActivityIndicator];
             [self messageError:error.localizedDescription];
         }];
}

- (void)parseResponce:(id)responce {
    NSDictionary *dictionary = responce;
    if ([dictionary[@"status"] integerValue] == 0) {
        [self stopActivityIndicator];
        [self messageError:@"Нет ответа от сервера."];
    } else {
        _recipe.title = dictionary[@"answer"][@"title"];
        _recipe.ingredients = dictionary[@"answer"][@"ingredients"];
        _recipe.text = dictionary[@"answer"][@"text"];
        _recipe.imageURL = dictionary[@"answer"][@"imageURL"];
        [self fillData];
    }
}

- (void)fillData {
    [_labelTitle setText:_recipe.title];
    NSString *format = @"Ингредиенты:\n\n%@\n\nРецепт:\n\n%@";
    [_textView setText:[NSString stringWithFormat:format,
                        _recipe.ingredients,
                        _recipe.text]];
    [self resizeTextView];
    [self checkImage];
}

- (void)checkImage {
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:_recipe.imageURL
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (!image) {
                                                             NSLog(@"Load, cache and set image: %@", _recipe.imageURL);
                                                             [self loadImage];
                                                         } else {
                                                             NSLog(@"Set image: %@", _recipe.imageURL);
                                                             [_imageView setImage:image];
                                                             [self stopActivityIndicator];
                                                         }
                                                     }];
}

- (void)loadImage {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_recipe.imageURL]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             [_imageView setImage:image];
                             [[SDImageCache sharedImageCache] storeImage:image
                                                                  forKey:_recipe.imageURL];
                             [self stopActivityIndicator];
                         }];
}

- (void)messageError:(NSString *)error {
    UIAlertController * alertController;
    alertController = [Utils createAlertControllerWithStyleAlert:UIAlertControllerStyleAlert
                                                       withTitle:@"Ошибка"
                                                        withText:error
                                                  andButtonTitle:@"OK"
                                                      completion:^{
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }];
    UIAlertAction *alertAction;
    alertAction = [UIAlertAction actionWithTitle:@"Повторить"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             [_viewIndicator setHidden:NO];
                                             [_activityIndicator startAnimating];
                                             [self loadData];
                                         }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)stopActivityIndicator {
    if ([_activityIndicator isAnimating]) {
        [_viewIndicator setHidden:YES];
        [_activityIndicator stopAnimating];
    }
}

- (void)resizeTextView {
    [self.view layoutIfNeeded];
    CGRect frame = _viewContent.frame;
    CGSize sizeWidth = CGSizeMake(self.view.frame.size.width - 2 * (kMarginFromSuperview + kMarginFromViewContent), FLT_MAX);
    CGSize size = [_textView sizeThatFits:sizeWidth];
    frame.size.height += size.height - _textView.frame.size.height;
    [_layoutConstraint setConstant:frame.size.height];
}

@end