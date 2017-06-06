//
//  RSCrashCollector.m
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashCollector.h"
#import "RSCrashStorage.h"
#include <execinfo.h>

static BOOL _rs_show_log_ = YES;
static RSCrashCollector *_crash_collector_ = nil;

@interface RSCrashCollector()
@property (nonatomic, strong) RSCrashStorage *storage;

@end

@implementation RSCrashCollector
static void exceptionHandel(NSException *exception)
{
    [RSCrashCollector _logException:exception];
    
    [RSCrashCollector _profileException:exception];
    
    NSSetUncaughtExceptionHandler(NULL);
    [exception raise];
}

-(instancetype )init
{
    if (self = [super init])
    {
        self.storage = [RSCrashStorage new];
    }
    return self;
}

void stacktrace(int sig, siginfo_t *info, void *context)
{
    NSLog(@" - - - - - - - - - - - - - - signal:%d - - - - - - - - - - - - - - - - - ",sig);
    NSMutableString *mstr = [NSMutableString string];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i < frames; ++i)
    {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    NSLog(@"= = = = = = = = = = = = = \n%@\n= = = = = = = = = = = = = = ",mstr);
    [_crash_collector_.storage storageWithText:mstr];
}

+(void )startCollectAfter:(NSTimeInterval )timeInterval
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _crash_collector_ = [RSCrashCollector new];
        NSSetUncaughtExceptionHandler(exceptionHandel);
        
//        struct sigaction sigAction;
//        sigAction.sa_sigaction = stacktrace;
//        sigAction.sa_flags = SA_SIGINFO;
//        sigAction.sa_mask = SA_USERSPACE_MASK;
//        
////        sigemptyset(&sigAction.sa_mask);
//        sigaction(SIGQUIT, &sigAction, NULL);
//        sigaction(SIGILL , &sigAction, NULL);
//        sigaction(SIGTRAP, &sigAction, NULL);
//        sigaction(SIGABRT, &sigAction, NULL);
//        sigaction(SIGEMT , &sigAction, NULL);
//        sigaction(SIGFPE , &sigAction, NULL);
//        sigaction(SIGBUS , &sigAction, NULL);
//        sigaction(SIGSEGV, &sigAction, NULL);
//        sigaction(SIGSYS , &sigAction, NULL);
//        sigaction(SIGPIPE, &sigAction, NULL);
//        sigaction(SIGALRM, &sigAction, NULL);
//        sigaction(SIGXCPU, &sigAction, NULL);
//        sigaction(SIGXFSZ, &sigAction, NULL);
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
