//
//  RSCrashCollector.m
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashCollector.h"
#import "RSCrashStorage.h"

static BOOL _rs_show_log_ = YES;
static RSCrashCollector *_crash_collector_ = nil;

@interface RSCrashCollector()
@property (nonatomic, strong) RSCrashStorage *storage;

@end

@implementation RSCrashCollector
static void exceptionHandel(NSException *exception)
{
//    [RSCrashCollector _logException:exception];
    
    [RSCrashCollector _profileException:exception];
}

-(instancetype )init
{
    if (self = [super init])
    {
        self.storage = [RSCrashStorage new];
    }
    return self;
}

+(void )startCollectAfter:(NSTimeInterval )timeInterval
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _crash_collector_ = [RSCrashCollector new];
        NSSetUncaughtExceptionHandler(exceptionHandel);
    });
}

+(void )showLog:(BOOL )showLog
{
    _rs_show_log_ = showLog;
}

+(void )_logException:(NSException *)exception
{
    if (_rs_show_log_)
    {
        NSLog(@"👇 👇 👇 👇 👇 👇 👇 👇 👇 important exception 👇 👇 👇 👇 👇 👇 👇 👇 👇");
        NSLog(@"%@",[self _formatException:exception]);
        NSLog(@"👆 👆 👆 👆 👆 👆 👆 👆 👆 important exception 👆 👆 👆 👆 👆 👆 👆 👆 👆");
    }
}

+(NSString *)_formatException:(NSException *)exception
{
    NSString *formatLog = [NSString stringWithFormat:@"\n{\n\tname:%@\n\treason:%@\n\tuserInfo:%@\n\tcallStack:%@\n\tcallStackSymbols:%@\n}",exception.name,exception.reason,exception.userInfo,exception.callStackReturnAddresses,exception.callStackSymbols];
    return formatLog;
}

+(void )_profileException:(NSException *)exception
{
    [self _storageLogWithException:exception];
}

+(void )_storageLogWithException:(NSException *)exception
{
    [_crash_collector_.storage storageWithText:[self _formatException:exception]];
}
@end
