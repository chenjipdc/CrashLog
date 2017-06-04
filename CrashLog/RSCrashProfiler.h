//
//  RSCrashProfiler.h
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCrashProfiler : NSObject
/**
 starting now
 */
-(void )start;

/**
 starting
 @param timeInterval starting after seconds
 */
-(void )startAfter:(NSTimeInterval )timeInterval;
@end
