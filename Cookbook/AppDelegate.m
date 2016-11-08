//
//  AppDelegate.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 10.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "AppDelegate.h"

#import "CTypeViewController.h"
#import "CPreviewViewController.h"

#import "Utils.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

@synthesize menu;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Menu"
                                                     ofType:@"json"];
    NSString *JSON = [[NSString alloc] initWithContentsOfFile:path
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    menu = [NSJSONSerialization JSONObjectWithData:[JSON dataUsingEncoding:NSUTF8StringEncoding]
                                           options:kNilOptions
                                             error:nil];
    NSArray *array = menu[@"menu"];
    CTypeViewController *typeVC = [[CTypeViewController alloc] initWithMenu:array];
    CPreviewViewController *previewVC = [[CPreviewViewController alloc] init];
    UINavigationController *typeNC = [[UINavigationController alloc] initWithRootViewController:typeVC];
    UINavigationController *previewNC = [[UINavigationController alloc] initWithRootViewController:previewVC];
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:18.f
                                                                             weight:UIFontWeightLight]};
    [Utils applyNavigationBarDesignWithTranslucent:NO
                               withBackgroundColor:RGB(182.f, 72.f, 132.f)
                                withTextAttributes:textAttributes];
    UISplitViewController *mainSVC = [[UISplitViewController alloc] init];
    [mainSVC setViewControllers:@[typeNC, previewNC]];
    [mainSVC setMinimumPrimaryColumnWidth:0.f];
    [mainSVC setMaximumPrimaryColumnWidth:mainSVC.view.frame.size.width / 2];
    [mainSVC setPreferredPrimaryColumnWidthFraction:.24f];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor blackColor]];
    self.window.rootViewController = mainSVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end