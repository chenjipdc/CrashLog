//
//  RSCrashStorage.m
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashStorage.h"
@interface RSCrashStorage()

@end

@implementation RSCrashStorage
-(void )storageWithText:(NSString *)text
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSArray<NSString *> *arr = [dateString componentsSeparatedByString:@" "];
    if (arr.count > 1)
    {
        NSString *date = arr[0];
        NSString *time = arr[1];
        
        NSLog(@"date:%@  time:%@",date, time);
        
        NSString *sqlDateExists = [NSString stringWithFormat:@"SELECT count(*) AS \"num\" FROM %@ WHERE date=?",RSLogDateModel.className];
        FMResultSet *resultSet = [self.db executeQuery:sqlDateExists, date];
        if (resultSet)
        {
            if ([resultSet next])
            {
                NSLog(@"%d",[resultSet columnCount]);
                NSLog(@"%@",[resultSet columnNameForIndex:0]);
                NSInteger num = [resultSet intForColumn:@"num"];
                if (num == 0)
                {
                    NSString *sqlInsertDate = [NSString stringWithFormat:@"INSERT INTO %@ (createDate, date) VALUES (?,?)",RSLogDateModel.className];
                    BOOL flag = NO;
                    [self.db beginTransaction];
                    @try
                    {
                        flag = [self.db executeUpdate:sqlInsertDate, [NSDate date], date];
                    }
                    @catch(NSException *exception)
                    {
                        flag = NO;
                        NSLog(@"error:%@",exception.reason);
                    }
                    @finally
                    {
                        if (flag)
                        {
                            [self.db commit];
                        }
                        else
                        {
                            NSLog(@"insert date error:%@",[self.db lastErrorMessage]);
                            [self.db rollback];
                        }
                    }
                }
            }
            [resultSet close];
        }
        else
        {
            NSLog(@"count error:%@",[self.db lastErrorMessage]);
        }
        
        [self.db beginTransaction];
        NSString *sqlInsertTimeTable = [NSString stringWithFormat:@"INSERT INTO %@ (createDate, time, crashLog, logDateId, reachabilityStatus) VALUES (?, ?, ?, (SELECT logDateId FROM %@ WHERE date=?), ?);", RSLogTimeModel.className, RSLogDateModel.className];
        BOOL flag = NO;
        @try
        {
            flag = [self.db executeUpdate:sqlInsertTimeTable, [NSDate date], time, text, date, RSLogTimeModel.reachabilityStatus];
        }
        @catch(NSException *exception)
        {
            flag = NO;
            NSLog(@"error:%@",exception.reason);
        }
        @finally
        {
            if (flag)
            {
                NSLog(@"insert time succeed");
                [self.db commit];
            }
            else
            {
                [self.db rollback];
                NSLog(@"insert time error:%@",[self.db lastErrorMessage]);
            }
        }
    }
}
@end
