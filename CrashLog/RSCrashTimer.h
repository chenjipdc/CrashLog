//
//  RSCrashTimer.h
//  CrashLogDemo
//
//  Created by pdc on 2017/7/4.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCrashTimer : NSObject
@property (nonatomic, readonly, assign) BOOL resume;
@property (nonatomic, copy) void (^wakeUpCallback)();

-(void )resumeDefault;
-(void )resumeForever;

-(void )resumeTimeInterval:(NSTimeInterval )timeInterval;
@end
