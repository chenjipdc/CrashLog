//
//  RSCrashConfiguration.m
//  CrashLogDemo
//
//  Created by pdc on 2017/6/24.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashConfiguration.h"
#import <UIKit/UIKit.h>
static RSCrashConfiguration *_configuration_ = nil;

@implementation RSCrashConfiguration
+(instancetype )singleConfiguration
{
    if (_configuration_ == nil)
    {
        _configuration_ = [RSCrashConfiguration new];
        _configuration_.url = @"";
        _configuration_.origin = CGPointMake(300,64);
        _configuration_.radius = 25;
        _configuration_.timeInterval = 3.0;
    }
    return _configuration_;
}

-(CGPoint )origin
{
    CGPoint origin = _origin;
    if (origin.x < 0)
    {
        origin.x = 0;
    }
    if (origin.y < 0)
    {
        origin.y = 0;
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    if (origin.x + 2 * self.radius > CGRectGetWidth(rect))
    {
        origin.x = CGRectGetWidth(rect)-2*self.radius;
    }
    if (origin.y + 2 * self.radius > CGRectGetHeight(rect))
    {
        origin.y = CGRectGetHeight(rect) - 2*self.radius;
    }
    
    return origin;
}

-(CGFloat )radius
{
    if (_radius < 0)
    {
        _radius = 0;
    }
    if (_radius > 100)
    {
        _radius = 100;
    }
    return _radius;
}
@end
