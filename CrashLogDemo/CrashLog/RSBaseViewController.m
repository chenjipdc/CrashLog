//
//  RSBaseViewController.m
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSBaseViewController.h"
#import <objc/runtime.h>

@implementation UINavigationController(RSDismiss)
-(void )setDismiss:(void (^)())dismiss
{
    objc_setAssociatedObject(self, @selector(dismiss), dismiss, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void(^)())dismiss
{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@interface RSBaseViewController ()

@end

@implementation RSBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(_dismiss:)];
}

-(void )_dismiss:(id )sender
{
    if (self.navigationController.dismiss)
    {
        self.navigationController.dismiss();
    }
}
@end
