//
//  RSCrashConfiguration.h
//  CrashLogDemo
//
//  Created by pdc on 2017/6/24.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCrashConfiguration : NSObject
/** 目前用于给device显示连接的url，因为有时会忘记连接的环境，方便调试查看 */
@property (nonatomic, copy) NSString *url;

+(instancetype )singleConfiguration;
@end
