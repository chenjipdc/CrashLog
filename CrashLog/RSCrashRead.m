//
//  RSCrashRead.m
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashRead.h"

@implementation RSCrashRead
-(void )readDateLogWithIndex:(NSInteger )index max:(NSInteger )max data:(void(^)(NSInteger total, NSArray<RSLogDateModel *> *logDates))data
{
    NSInteger total = 0;
    NSString *sqlCount = [NSString stringWithFormat:@"SELECT count(*) AS total FROM %@",RSLogDateModel.className];
    FMResultSet *countResult = [self.db executeQuery:sqlCount];
    if (countResult)
    {
        if ([countResult next])
        {
            total = [countResult intForColumn:@"total"];
        }
        [countResult close];
    }
    else
    {
        NSLog(@"read count error:%@",[self.db lastErrorMessage]);
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sqlDateLog = [NSString stringWithFormat:@"SELECT *FROM %@ ORDER BY logDateId DESC LIMIT %@,%@ ",RSLogDateModel.className,@(index),@(max)];
    FMResultSet *dateLogResult = [self.db executeQuery:sqlDateLog];
    if (dateLogResult)
    {
        while ([dateLogResult next])
        {
            RSLogDateModel *model = [RSLogDateModel new];
            model.date = [dateLogResult objectForColumnName:@"date"];
            model.logDateId = [[dateLogResult objectForColumnName:@"logDateId"] integerValue];
            [arr addObject:model];
        }
        if (data)
        {
            data(total, [arr copy]);
        }
    }
    else
    {
        NSLog(@"dateLogResult error:%@",[self.db lastErrorMessage]);
    }
}

-(void )readTimeLogWithIndex:(NSInteger )index max:(NSInteger )max logDateId:(NSInteger )logDateId data:(void(^)(NSInteger total, NSArray<RSLogTimeModel *> *logTimes))data
{
    NSInteger total = 0;
    NSString *sqlCount = [NSString stringWithFormat:@"SELECT count(*) AS total FROM %@ WHERE logDateId=%@",RSLogTimeModel.className,@(logDateId)];
    FMResultSet *countResult = [self.db executeQuery:sqlCount];
    if (countResult)
    {
        if ([countResult next])
        {
            total = [countResult intForColumn:@"total"];
        }
        [countResult close];
    }
    else
    {
        NSLog(@"read count error:%@",[self.db lastErrorMessage]);
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sqlDateLog = [NSString stringWithFormat:@"SELECT *FROM %@ WHERE logDateId=%@ ORDER BY logTimeId DESC LIMIT %@,%@ ",RSLogTimeModel.className,@(logDateId),@(index),@(max)];
    FMResultSet *dateLogResult = [self.db executeQuery:sqlDateLog];
    if (dateLogResult)
    {
        while ([dateLogResult next])
        {
            RSLogTimeModel *model = [RSLogTimeModel new];
            model.time = [dateLogResult objectForColumnName:@"time"];
            model.logDateId = [[dateLogResult objectForColumnName:@"logDateId"] integerValue];
            model.logTimeId = [[dateLogResult objectForColumnName:@"logTimeId"] integerValue];
            model.crashLog = [dateLogResult objectForColumnName:@"crashLog"];
            [arr addObject:model];
        }
        if (data)
        {
            data(total, [arr copy]);
        }
    }
    else
    {
        NSLog(@"dateLogResult error:%@",[self.db lastErrorMessage]);
    }
}


-(void )readDeviceData:(void(^)(RSDeviceModel *deviceModel))deviceData
{
    NSString *sqlSelectDevice = [NSString stringWithFormat:@"SELECT *FROM %@ LIMIT 1",RSDeviceModel.className];
    FMResultSet *deviceResult = [self.db executeQuery:sqlSelectDevice];
    if (deviceResult)
    {
        RSDeviceModel *device = nil;
        if ([deviceResult next])
        {
            device = [RSDeviceModel new];
            device.name = [deviceResult objectForColumnName:@"name"];
            device.model = [deviceResult objectForColumnName:@"model"];
            device.localizedModel = [deviceResult objectForColumnName:@"localizedModel"];
            device.systemName = [deviceResult objectForColumnName:@"systemName"];
            device.systemVersion = [deviceResult objectForColumnName:@"systemVersion"];
            device.uuid = [deviceResult objectForColumnName:@"uuid"];
            device.appVersion = [deviceResult objectForColumnName:@"appVersion"];
        }
        [deviceResult close];
        if (deviceData)
        {
            deviceData(device);
        }
    }
    else
    {
        NSLog(@"select device error:%@",[self.db lastErrorMessage]);
    }
}
@end
