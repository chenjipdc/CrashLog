//
//  RSCrashDB.m
//  RSDebugCrash
//
//  Created by pdc on 2017/5/31.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDB.h"

static NSString *const _rs_db_path_ = @"/Documents/crash_log.db";
@interface RSCrashDB()
@property (nonatomic, readwrite, strong) FMDatabase *db;

@end

@implementation RSCrashDB

-(instancetype )init
{
    if (self = [super init])
    {
        NSLog(@"%@",NSHomeDirectory());
        self.db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),_rs_db_path_]];
        if (![self.db open])
        {
            NSLog(@"db open error:%@",[self.db lastErrorMessage]);
            return nil;
        }
        [self createTable];
        [self alterColumn];
//        [self dropAllTable];
    }
    return self;
}

-(void )dealloc
{
    [self.db close];
}

/** 创建表 */
-(void )createTable
{
    NSString *statements = [NSString stringWithFormat:@"%@%@",[RSLogDateModel sqlCreateTable],[RSLogTimeModel sqlCreateTable]];
    NSLog(@"statememts:%@",statements);
    NSLog(@"get property type:%@",[RSLogDateModel sqlTypeFromPropertyName:@"createDate"]);
    if ([self.db executeStatements:statements])
    {
        NSLog(@"create succeed!");
    }
    else
    {
        NSLog(@"create error:%@",[self.db lastErrorMessage]);
    }
}

/** 增加列，用于设计表时暂时想不到的列 */
-(void )alterColumn
{
    
}

/** 清空表数据 */
-(void )clearAllTable
{
    
}

-(void )clearTableWithName:(NSString *)name
{
    
}

/** 删除表 */
-(void )dropAllTable
{
    if([self.db executeStatements:[NSString stringWithFormat:@"%@%@",[RSLogDateModel sqlDropTable],[RSLogTimeModel sqlDropTable]]])
    {
        NSLog(@"drop all table succeed!");
    }
    else
    {
        NSLog(@"drop table failed:%@",[self.db lastErrorMessage]);
    }
}

-(void )dropTableWithName:(NSString *)name
{
    
}
@end
