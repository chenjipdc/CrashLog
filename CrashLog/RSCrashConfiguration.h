//
//  RSCrashConfiguration.h
//  CrashLogDemo
//
//  Created by pdc on 2017/6/24.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface RSCrashConfiguration : NSObject
/** 目前用于给device显示连接的url，因为有时会忘记连接的环境，方便调试查看 */
@property (nonatomic, copy) NSString *url;

/** 设置圆起始位置，默认 300 x 64 */
@property (nonatomic, assign) CGPoint origin;

/** 设置起始直径，默认 25，最大100 */
@property (nonatomic, assign) CGFloat radius;

/** 设置多长时间后靠边，默认3秒 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

+(instancetype )singleConfiguration;
@end
