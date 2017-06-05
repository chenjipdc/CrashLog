//
//  RSCrashDelete.h
//  CrashLogDemo
//
//  Created by pdc on 2017/6/4.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDB.h"

@interface RSCrashDelete : RSCrashDB

/**
 delete RSDateLogModel where logDateId

 @param logDateId id
 @param state callback，YES succeed； NO failed or error
 */
-(void )deleteRecordWithLogDateId:(NSInteger )logDateId state:(void(^)(BOOL state)) state;

/**
 delete RSTimeLogModel where logTimeId
 
 @param logTimeId id
 @param state callback，YES succeed； NO failed or error
 */
-(void )deleteRecordWithLogTimeId:(NSInteger )logTimeId state:(void(^)(BOOL state)) state;
@end
