# CrashLog

## How to use CrashLog?
#### install
```objectivec
pod 'CrashLog'
```
- - -
#### like this
```objectivec
@interface AppDelegate ()
@property (nonatomic, strong) RSCrashProfiler *profiler;
@end

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
self.profiler = [RSCrashProfiler new];
[self.profiler start];
return YES;
}
```
