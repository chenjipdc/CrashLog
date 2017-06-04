//
//  RSCrashWindow.m
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashWindow.h"

@implementation RSCrashWindow
-(instancetype )initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 200;
    }
    return self;
}

-(BOOL )pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.shouldReciveTouchAtPoint
        && self.shouldReciveTouchAtPoint(self, point))
    {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

@end
