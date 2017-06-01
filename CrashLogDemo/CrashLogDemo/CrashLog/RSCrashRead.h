//
//  RSCrashRead.h
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDB.h"

@interface RSCrashRead : RSCrashDB
-(void )readDateLogWithIndex:(NSInteger )index max:(NSInteger )max data:(void(^)(NSInteger total, NSArray<RSLogDateModel *> *logDates))data;

-(void )readTimeLogWithIndex:(NSInteger )index max:(NSInteger )max logDateId:(NSInteger )logDateId data:(void(^)(NSInteger total, NSArray<RSLogTimeModel *> *logTimes))data;
@end
