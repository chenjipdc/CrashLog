//
//  RSCrashCollector.h
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCrashCollector : NSObject

+(void )startCollectAfter:(NSTimeInterval )timeInterval;


/**
 show crash log

 @param showLog default YES
 */
+(void )showLog:(BOOL )showLog;
@end
