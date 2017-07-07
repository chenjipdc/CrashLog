//
//  RSCrashTimer.m
//  CrashLogDemo
//
//  Created by pdc on 2017/7/4.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashTimer.h"
#import "RSCrashConfiguration.h"

@interface RSCrashTimer()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, readwrite, assign) BOOL resume;

@end

@implementation RSCrashTimer
-(instancetype )init
{
    if (self = [super init])
    {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            weakSelf.resume = NO;
            if (weakSelf.wakeUpCallback)
            {
                weakSelf.wakeUpCallback();
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self resumeDefault];
    }
    return self;
}

-(void )dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void )resumeDefault
{
    [self resumeTimeInterval:[RSCrashConfiguration singleConfiguration].timeInterval];
}

-(void )resumeForever
{
    self.resume = YES;
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void )resumeTimeInterval:(NSTimeInterval )timeInterval
{
    self.resume = YES;
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}
@end
