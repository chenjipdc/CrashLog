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
        
        [self autoStorage];
    }
    return self;
}

-(void )dealloc
{
    [self.db close];
}

/** create table */
-(void )createTable
{
    NSString *statements = [NSString stringWithFormat:@"%@%@%@",[RSLogDateModel sqlCreateTable],[RSLogTimeModel sqlCreateTable],[RSDeviceModel sqlCreateTable]];
//    NSLog(@"statememts:%@",statements);
//    NSLog(@"get property type:%@",[RSLogDateModel sqlTypeFromPropertyName:@"createDate"]);
    if ([self.db executeStatements:statements])
    {
        NSLog(@"create succeed!");
    }
    else
    {
        NSLog(@"create error:%@",[self.db lastErrorMessage]);
    }
}

/** auto storage */
-(void )autoStorage
{
    NSString *sqlExistsDevice = [NSString stringWithFormat:@"SELECT count(*) AS count FROM %@",RSDeviceModel.className];
    FMResultSet *deviceResult = [self.db executeQuery:sqlExistsDevice];
    if (deviceResult)
    {
        if ([deviceResult next])
        {
            int count = [deviceResult intForColumn:@"count"];
            if (count == 0)
            {
                NSString *sqlStoreDevice = [NSString stringWithFormat:@"INSERT INTO %@ (name,model,localizedModel,systemName,systemVersion,uuid,appVersion) VALUES(?,?,?,?,?,?,?)",RSDeviceModel.className];
                if ([self.db executeUpdate:sqlStoreDevice,RSDeviceModel.name,RSDeviceModel.model,RSDeviceModel.localizedModel,RSDeviceModel.systemName,RSDeviceModel.systemVersion,RSDeviceModel.uuid,RSDeviceModel.appVersion])
                {
                    NSLog(@"store device succeed!");
                }
                else
                {
                    NSLog(@"store device error:%@",[self.db lastErrorMessage]);
                }
            }
        }
        [deviceResult close];
    }
    else
    {
        NSLog(@"error sql exists device: %@",[self.db lastErrorMessage]);
    }
}

/** alter column */
-(void )alterColumn
{
//    NSString *sqlTimeModelAddCrashType = [NSString stringWithFormat:@"ALTER TABLE %@ ADD crashType TEXT",RSLogTimeModel.className];
    
//    NSString *sqlColumnExists = [NSString stringWithFormat:@"select * from %@;",RSLogTimeModel.className];
//    FMResultSet *result = [self.db executeQuery:sqlColumnExists];
//    if ([result next])
//    {
//        NSLog(@"%@",[result columnNameToIndexMap]);
//    }
//    else
//    {
//        NSLog(@"error:%@",[self.db lastErrorMessage]);
//    }
}

-(void )alterConstrain
{
    
}

/** clear table */
-(void )clearAllTable
{
    
}

-(void )clearTableWithName:(NSString *)name
{
    
}

/** remove table */
-(void )dropAllTable
{
    if([self.db executeStatements:[NSString stringWithFormat:@"%@%@%@",[RSLogDateModel sqlDropTable],[RSLogTimeModel sqlDropTable],[RSDeviceModel sqlDropTable]]])
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
