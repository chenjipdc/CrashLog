//
//  RSCrashContainerViewController.h
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCrashContainerViewController : UIViewController

/** load controller,frame */
-(void )containerController:(__kindof UIViewController *)controller frame:(CGRect )frame;

/** remove controller，the same exchange controller */
-(void )dismissContainerController;

@property (nonatomic, assign) CGFloat edgeLeftOrRight;
@property (nonatomic, copy) void(^moveCallback) ();
@end
