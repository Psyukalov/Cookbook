//
//  CustomTimer.m
//  Cookbook
//
//  Created by Vladimir Psyukalov on 10.06.16.
//  Copyright © 2016 com.NataliaZubareva.Cookbook. All rights reserved.
//


#import "CustomTimer.h"


@interface CustomTimer ()

@property (assign, nonatomic) NSUInteger time;
@property (assign, nonatomic) NSUInteger count;

@property (strong, nonatomic) NSTimer *timer;

@end


@implementation CustomTimer

@synthesize delegate;

- (instancetype)initTimerWithTime:(NSUInteger)time {
    self = [super init];
    if (self) {
        _time = time;
    }
    return self;
}

- (void)start {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                              target:self
                                            selector:@selector(tick)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stop {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)tick {
    if (_count < _time) {
        _count++;
    } else {
        if (delegate) {
            [delegate didEndTimer];
        }
        _count = 0;
    }
}

@end