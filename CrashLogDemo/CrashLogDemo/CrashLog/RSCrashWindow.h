//
//  RSCrashWindow.h
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCrashWindow : UIWindow
/** perform window events, some area need to action */
@property (nonatomic, copy) BOOL (^shouldReciveTouchAtPoint)(RSCrashWindow *window,CGPoint point);

@end
