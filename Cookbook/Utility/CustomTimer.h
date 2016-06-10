//
//  CustomTimer.h
//  Cookbook
//
//  Created by Vladimir Psyukalov on 10.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol CustomTimerDelegate <NSObject>

- (void)didEndTimer;

@end


@interface CustomTimer : NSObject

@property (assign, nonatomic) id delegate;

- (instancetype)initTimerWithTime:(NSUInteger)time;

- (void)start;

- (void)stop;

@end