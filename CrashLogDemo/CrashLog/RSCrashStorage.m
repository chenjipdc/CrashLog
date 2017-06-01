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
                    if ([self.db executeUpdate:sqlInsertDate, [NSDate date], date])
                    {
                        NSLog(@"insert date succeed!");
                    }
                    else
                    {
                        NSLog(@"insert date error:%@",[self.db lastErrorMessage]);
                    }
                }
            }
            [resultSet close];
        }
        else
        {
            NSLog(@"count error:%@",[self.db lastErrorMessage]);
        }
        
        NSString *sqlSelectDateId = [NSString stringWithFormat:@"SELECT logDateId FROM %@ WHERE date=?",RSLogDateModel.className];
        FMResultSet *dateResult = [self.db executeQuery:sqlSelectDateId, date];
        if (dateResult)
        {
            if ([dateResult next])
            {
                NSString *sqlInsertTime = [NSString stringWithFormat:@"INSERT INTO %@ (createDate, time, crashLog, logDateId) VALUES (?,?,?,?)", RSLogTimeModel.className];
                if ([self.db executeUpdate:sqlInsertTime, [NSDate date], time, text, @([dateResult intForColumn:@"logDateId"])])
                {
                    NSLog(@"insert time succeed");
                }
                else
                {
                    NSLog(@"insert time error:%@",[self.db lastErrorMessage]);
                }
            }
            [dateResult close];
        }
        else
        {
            NSLog(@"logDateId error:%@",[self.db lastErrorMessage]);
        }
    }
}
@end
