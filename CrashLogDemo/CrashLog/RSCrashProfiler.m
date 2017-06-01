//
//  RSCrashProfiler.m
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashProfiler.h"
#import "RSCrashCollector.h"
#import "RSCrashWindow.h"
#import "RSCrashContainerViewController.h"

#import "RSCrashClickViewController.h"
#import "RSCrashLogViewController.h"

static CGFloat _click_width_ = 50;

typedef NS_ENUM(NSInteger, RSCrashShowType)
{
    RSCrashShowTypeClick,
    RSCrashShowTypeLog
};

@interface RSCrashProfiler()
@property (nonatomic, strong) RSCrashWindow *Window;

@property (nonatomic, strong) RSCrashContainerViewController *containerController;

@property (nonatomic, strong) RSCrashClickViewController *clickController;
@property (nonatomic, strong) RSCrashLogViewController *logController;
@property (nonatomic, strong) UINavigationController *navController;

@property (nonatomic, assign) RSCrashShowType type;
@end

@implementation RSCrashProfiler
{
    CGRect _lastClickFrame;
    CGRect _lastLogFrame;
}

-(instancetype )init
{
    if (self = [super init])
    {
//        [self start];
    }
    return self;
}

-(RSCrashClickViewController *)clickController
{
    if (_clickController == nil)
    {
        __weak typeof(self) weakSelf = self;
        _clickController = [RSCrashClickViewController new];
        _clickController.clickAction = ^{
            [weakSelf _showType:RSCrashShowTypeLog];
        };
        
    }
    return _clickController;
}

-(RSCrashLogViewController *)logController
{
    if (_logController == nil)
    {
        _logController = [RSCrashLogViewController new];
    }
    return _logController;
}

-(UINavigationController *)navController
{
    if (_navController == nil)
    {
        _navController = [[UINavigationController alloc] initWithRootViewController:self.logController];
        __weak typeof(self) weakSelf = self;
        _navController.dismiss = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf _showType:RSCrashShowTypeClick];
        };
    }
    return _navController;
}

-(void )start
{
    [self startAfter:0];
}

-(void )startAfter:(NSTimeInterval )timeInterval
{
    [RSCrashCollector startCollectAfter:timeInterval];
    [self createContainer];
}

-(void )createContainer
{
    self.containerController = [RSCrashContainerViewController new];
    self.Window = [[RSCrashWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.Window.hidden = NO;
    self.Window.rootViewController = self.containerController;
    __weak typeof(self) weakSelf = self;
    self.Window.shouldReciveTouchAtPoint = ^BOOL(RSCrashWindow *window, CGPoint point) {
        switch (weakSelf.type)
        {
            case RSCrashShowTypeClick:
                return CGRectContainsPoint(weakSelf.clickController.view.bounds,[weakSelf.clickController.view convertPoint:point fromView:window]);
            case RSCrashShowTypeLog:
                return CGRectContainsPoint(weakSelf.navController.view.bounds,[weakSelf.navController.view convertPoint:point fromView:window]);
            default:
                return NO;
        }
    };
    [self _showType:0];
}

-(void )_showType:(RSCrashShowType )type
{
    self.type = type;
    if (self.type == RSCrashShowTypeLog)
    {
        if (!CGRectEqualToRect(_lastClickFrame, CGRectZero))
        {
            _lastClickFrame = self.clickController.view.frame;
        }
    }
    else
    {
        if (!CGRectEqualToRect(_lastLogFrame, CGRectZero))
        {
            _lastLogFrame = self.navController.view.frame;
        }
    }
    [self.containerController dismissContainerController];
    switch (type)
    {
        case RSCrashShowTypeClick:
            if (CGRectEqualToRect(_lastClickFrame, CGRectZero))
            {
                _lastClickFrame = CGRectMake(100, 100, _click_width_, _click_width_);
            }
            [self.containerController containerController:self.clickController frame:_lastClickFrame];
            break;
        case RSCrashShowTypeLog:
            if (CGRectEqualToRect(_lastLogFrame, CGRectZero))
            {
                _lastLogFrame = CGRectMake(100, 100, 200, 300);
            }
            [self.containerController containerController:self.navController frame:_lastLogFrame];
            break;
        default:
            if (CGRectEqualToRect(_lastClickFrame, CGRectZero))
            {
                _lastClickFrame = CGRectMake(100, 100, _click_width_, _click_width_);
            }
            [self.containerController containerController:self.clickController frame:_lastClickFrame];
            break;
    }
}
@end
