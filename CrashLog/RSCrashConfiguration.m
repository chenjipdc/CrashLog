//
//  RSCrashConfiguration.m
//  CrashLogDemo
//
//  Created by pdc on 2017/6/24.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashConfiguration.h"

static RSCrashConfiguration *_configuration_ = nil;

@implementation RSCrashConfiguration
+(instancetype )singleConfiguration
{
    if (_configuration_ == nil)
    {
        _configuration_ = [RSCrashConfiguration new];
        _configuration_.url = @"";
    }
    return _configuration_;
}

@end
