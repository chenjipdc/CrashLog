//
//  RSCrashDelete.h
//  CrashLogDemo
//
//  Created by pdc on 2017/6/4.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDB.h"

@interface RSCrashDelete : RSCrashDB
-(void )deleteRecordWithLogDateId:(NSInteger )logDateId state:(void(^)(BOOL state)) state;

-(void )deleteRecordWithLogTimeId:(NSInteger )logTimeId state:(void(^)(BOOL state)) state;
@end
