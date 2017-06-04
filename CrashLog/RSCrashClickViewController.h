//
//  RSCrashClickViewController.h
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCrashClickViewController : UIViewController

@property (nonatomic, copy) void (^clickAction)();

@end
