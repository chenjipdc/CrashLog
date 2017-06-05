//
//  RSCrashDelete.m
//  CrashLogDemo
//
//  Created by pdc on 2017/6/4.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDelete.h"

@implementation RSCrashDelete
-(void )deleteRecordWithLogDateId:(NSInteger )logDateId state:(void(^)(BOOL state)) state
{
    BOOL flag = NO;
    if (![self.db inTransaction])
    {
        [self.db beginTransaction];
    }
    else
    {
        [self.db beginDeferredTransaction];
    }
    
    @try
    {
        NSString *sqlDateDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE logDateId=%@;",RSLogDateModel.className,@(logDateId)];
        NSString *sqlTimeDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE logDateId=%@;",RSLogTimeModel.className,@(logDateId)];
        flag = [self.db executeStatements:[NSString stringWithFormat:@"%@%@",sqlDateDelete,sqlTimeDelete]];
        if (!flag)
        {
            NSLog(@"delete logDateId = %@ error:%@",@(logDateId),[self.db lastErrorMessage]);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"delete logDateId = %@ error:%@",@(logDateId),[self.db lastErrorMessage]);
        flag = NO;
    }
    @finally
    {
        if (flag)
        {
            flag = [self.db commit];
        }
        else
        {
            [self.db rollback];
        }
    }
    if (state)
    {
        state(flag);
    }
}

-(void )deleteRecordWithLogTimeId:(NSInteger )logTimeId state:(void(^)(BOOL state)) state
{
    BOOL flag = NO;
    if (![self.db inTransaction])
    {
        [self.db beginTransaction];
    }
    else
    {
        [self.db beginDeferredTransaction];
    }
    @try
    {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE logTimeId=?",RSLogTimeModel.className];
        flag = [self.db executeUpdate:sqlDelete,@(logTimeId)];
    }
    @catch (NSException *exception)
    {
        NSLog(@"delete logTimeId = %@ error:%@",@(logTimeId),[self.db lastErrorMessage]);
        flag = NO;
    }
    @finally
    {
        if (flag)
        {
            flag = [self.db commit];
        }
        else
        {
            [self.db rollback];
        }
    }
    if (state)
    {
        state(flag);
    }
}

@end
