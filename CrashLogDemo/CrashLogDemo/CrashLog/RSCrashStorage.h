//
//  RSCrashStorage.h
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDB.h"

@interface RSCrashStorage : RSCrashDB

-(void )storageWithText:(NSString *)text;

@end
