//
//  TypeViewController.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 10.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "TypeViewController.h"

#import "Cookbook-Swift.h"

#import "AppDelegate.h"

#import "CustomTimer.h"

#import "ContentViewController.h"


#define kExternalMargin (256.f)
#define kTime (4)


@interface TypeViewController () <CustomTimerDelegate>

@property (weak, nonatomic) IBOutlet SpringView *viewContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSplash;

@property (weak, nonatomic) IBOutlet UILabel *labelType;

@property (weak, nonatomic) IBOutlet UIButton *buttonChoise;
@property (weak, nonatomic) IBOutlet UIButton *buttonPrevios;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;

@property (assign, nonatomic) NSUInteger type;
@property (assign, nonatomic) NSUInteger maxType;

@property (strong, nonatomic) NSDictionary *menu;

@property (strong, nonatomic) NSMutableArray <NSString *> *types;
@property (strong, nonatomic) NSMutableArray <UIImage *> *images;

@property (strong, nonatomic) CustomTimer *timer;

@end


@implementation TypeViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self applySetup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self applyDesign];
    _timer = [[CustomTimer alloc] initTimerWithTime:kTime];
    [_timer setDelegate:self];
    [_timer start];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Custom methods

- (void)applySetup {
    _menu = [(AppDelegate *)[[UIApplication sharedApplication] delegate] menu];
    _type = 0;
    NSArray *array = _menu[@"menu"];
    _maxType = array.count;
    _types = [[NSMutableArray alloc] init];
    _images = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i <= _maxType - 1; i++) {
        [_types addObject:array[i][@"name"]];
        [_images addObject:[UIImage imageNamed:array[i][@"image"]]];
    }
    [self fillViewControllerWithType:0];
}

- (void)applyDesign {
    CALayer *layer = [CALayer layer];
    CGRect frame = CGRectMake(-128.f, -128.f, 2048.f, 2048.f);
    [layer setFrame:frame];
    [layer setBackgroundColor:[UIColor blackColor].CGColor];
    [layer setOpacity:.42f];
    [_imageViewSplash.layer addSublayer:layer];
    [_buttonChoise.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonChoise.layer setBorderWidth:2.f];
    [_buttonChoise.layer setCornerRadius:_buttonChoise.frame.size.height / 2];
    [_buttonChoise.layer setMasksToBounds:YES];
    [_buttonNext.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonNext.layer setBorderWidth:2.f];
    [_buttonNext.layer setCornerRadius:_buttonNext.frame.size.height / 2];
    [_buttonNext.layer setMasksToBounds:YES];
    [_buttonPrevios.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_buttonPrevios.layer setBorderWidth:2.f];
    [_buttonPrevios.layer setCornerRadius:_buttonPrevios.frame.size.height / 2];
    [_buttonPrevios.layer setMasksToBounds:YES];
}

- (void)fillViewControllerWithType:(NSInteger)type {
    [_labelType setText:_types[type]];
    [_imageViewSplash setImage:_images[type]];
    NSInteger nextType = type + 1;
    NSInteger previosType = type - 1;
    if (nextType > _maxType - 1) {
        nextType = 0;
    }
    if (previosType < 0) {
        previosType = _maxType - 1;
    }
    [_buttonPrevios setTitle:_types[previosType]
                    forState:UIControlStateNormal];
    [_buttonNext setTitle:_types[nextType]
                 forState:UIControlStateNormal];
}

- (void)nextMenu {
    if (_type < _maxType - 1) {
        _type++;
    } else {
        _type = 0;
    }
    [self fillViewControllerWithType:_type];
    [_viewContent setAnimation:@"fadeInLeft"];
    [_viewContent animate];
}

- (void)previosMenu {
    if (_type > 0) {
        _type--;
    } else {
        _type = _maxType - 1;
    }
    [self fillViewControllerWithType:_type];
    [_viewContent setAnimation:@"fadeInRight"];
    [_viewContent animate];
}

#pragma mark - CustomTimerDelegate

- (void)didEndTimer {
    [self nextMenu];
}

#pragma mark - Actions

- (IBAction)buttonChoise_TUI:(UIButton *)sender {
    ContentViewController *contentVC = [[ContentViewController alloc] initWithRecipes:_menu[@"menu"][_type]];
    [self presentViewController:contentVC
                       animated:YES
                     completion:nil];
}

- (IBAction)leftSwipe_SEL:(UISwipeGestureRecognizer *)sender {
    [self nextMenu];
    [_timer stop];
}

- (IBAction)rightSwipe_SEL:(UISwipeGestureRecognizer *)sender {
    [self previosMenu];
    [_timer stop];
}

- (IBAction)buttonPrevios_TUI:(UIButton *)sender {
    [self previosMenu];
    [_timer stop];
}

- (IBAction)buttonNext_TUI:(UIButton *)sender {
    [self nextMenu];
    [_timer stop];
}

@end