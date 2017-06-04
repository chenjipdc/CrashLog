//
//  RSCrashDB.h
//  RSDebugCrash
//
//  Created by pdc on 2017/5/31.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSTableModel.h"
#import <FMDB/FMDB.h>

@interface RSCrashDB : NSObject
@property (nonatomic, readonly, strong) FMDatabase *db;


/** clear table */
-(void )clearAllTable;
-(void )clearTableWithName:(NSString *)name;

/** drop table */
-(void )dropAllTable;
-(void )dropTableWithName:(NSString *)name;
@end
