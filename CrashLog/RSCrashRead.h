//
//  RSCrashRead.h
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDB.h"

@interface RSCrashRead : RSCrashDB

/**
 read RSDateLogModel table data

 @param index index
 @param max max of the datas
 @param data result callback
 */
-(void )readDateLogWithIndex:(NSInteger )index max:(NSInteger )max data:(void(^)(NSInteger total, NSArray<RSLogDateModel *> *logDates))data;

/**
 read RSTimeLogModel table data
 
 @param index index
 @param max max of the datas
 @param data result callback
 */
-(void )readTimeLogWithIndex:(NSInteger )index max:(NSInteger )max logDateId:(NSInteger )logDateId data:(void(^)(NSInteger total, NSArray<RSLogTimeModel *> *logTimes))data;



/**
 read RSDeviceModel table data

 @param deviceData result callback
 */
-(void )readDeviceData:(void(^)(RSDeviceModel *deviceModel))deviceData;
@end
