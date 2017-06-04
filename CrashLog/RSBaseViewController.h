//
//  RSBaseViewController.h
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(RSDismiss)
@property (nonatomic, copy) void(^dismiss) ();

@end

@interface RSBaseViewController : UIViewController

@end
