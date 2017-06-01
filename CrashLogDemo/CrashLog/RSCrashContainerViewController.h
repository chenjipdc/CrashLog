//
//  RSCrashContainerViewController.h
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCrashContainerViewController : UIViewController

/** 加载controller,frame */
-(void )containerController:(__kindof UIViewController *)controller frame:(CGRect )frame;

/** 移除controller，相当于切换 */
-(void )dismissContainerController;
@end
