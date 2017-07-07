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
        self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
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

-(void )timerRun:(NSTimer *)timer
{
    self.resume = NO;
    if (self.wakeUpCallback)
    {
        self.wakeUpCallback();
    }
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
