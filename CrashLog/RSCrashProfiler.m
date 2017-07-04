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

#import "RSCrashConfiguration.h"
#import "RSCrashTimer.h"

typedef NS_ENUM(NSInteger, RSCrashShowType)
{
    RSCrashShowTypeClick,   //show click button
    RSCrashShowTypeLog      //show log
};

@interface RSCrashProfiler()
@property (nonatomic, strong) RSCrashWindow *Window;

@property (nonatomic, strong) RSCrashContainerViewController *containerController;

@property (nonatomic, strong) RSCrashClickViewController *clickController;
@property (nonatomic, strong) RSCrashLogViewController *logController;
@property (nonatomic, strong) UINavigationController *navController;

@property (nonatomic, assign) RSCrashShowType type;

@property (nonatomic, strong) RSCrashTimer *timer;
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
        __weak typeof(self) weakSelf = self;
        self.timer = [RSCrashTimer new];
        self.timer.wakeUpCallback = ^{
            [weakSelf _moveToSideClickButton];
        };
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
    __weak typeof(self) weakSelf = self;
    self.containerController = [RSCrashContainerViewController new];
    self.containerController.moveCallback = ^{
        if (weakSelf.type == RSCrashShowTypeClick)
        {
            [weakSelf.timer resumeDefault];
        }
    };
    
    //window
    self.Window = [[RSCrashWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.Window.hidden = NO;
    self.Window.rootViewController = self.containerController;
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
    
    CGFloat diameter = [RSCrashConfiguration singleConfiguration].radius * 2;
    CGPoint origin = [RSCrashConfiguration singleConfiguration].origin;
    
    switch (type)
    {
        case RSCrashShowTypeClick:
            [self.timer resumeDefault];
            if (CGRectEqualToRect(_lastClickFrame, CGRectZero))
            {
                _lastClickFrame = CGRectMake(origin.x, origin.y, diameter, diameter);
            }
            self.containerController.edgeLeftOrRight = diameter*0.5;
            [self.containerController containerController:self.clickController frame:_lastClickFrame];
            break;
        case RSCrashShowTypeLog:
            [self.timer resumeForever];
            if (CGRectEqualToRect(_lastLogFrame, CGRectZero))
            {
                _lastLogFrame = CGRectMake(100, 100, 200, 300);
            }
            self.containerController.edgeLeftOrRight = 0;
            [self.containerController containerController:self.navController frame:_lastLogFrame];
            break;
        default:
            [self.timer resumeDefault];
            if (CGRectEqualToRect(_lastClickFrame, CGRectZero))
            {
                _lastClickFrame = CGRectMake(origin.x, origin.y, diameter, diameter);
            }
            self.containerController.edgeLeftOrRight = diameter*0.5;
            [self.containerController containerController:self.clickController frame:_lastClickFrame];
            break;
    }
}

-(void )_moveToSideClickButton
{
    CGPoint center = self.clickController.view.center;
    CGRect rect = [UIScreen mainScreen].bounds;
    if (center.x > 0.5 && center.x <= CGRectGetMidX(rect))
    {
        center.x = 0;
    }
    else if (center.x > CGRectGetMidX(rect) && center.x <= CGRectGetWidth(rect)-0.5)
    {
        center.x = CGRectGetWidth([UIScreen mainScreen].bounds)-0.5;
    }
    [self.timer resumeDefault];
    [UIView animateWithDuration:0.5 animations:^{
        self.clickController.view.center = center;
    }];
}
@end
