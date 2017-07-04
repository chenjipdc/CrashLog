//
//  RSCrashContainerViewController.m
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashContainerViewController.h"

@interface RSCrashContainerViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) __kindof UIViewController *presentController;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinch;
@end

@implementation RSCrashContainerViewController
{
    CGFloat _pinch_width;
    CGFloat _pinch_height;
    CGFloat _pinch_x;
    CGFloat _pinch_y;
//    CGRect _frame;
//    CGRect _self_last_frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
}

//-(void )viewDidLayoutSubviews
//{
//    CGFloat width = CGRectGetWidth(self.view.bounds);
//    CGFloat height = CGRectGetHeight(self.view.bounds);
//    
//    CGFloat last_width = CGRectGetWidth(_self_last_frame);
//    CGFloat last_height = CGRectGetHeight(_self_last_frame);
//    CGFloat x_scale = _frame.origin.x/last_width;
//    CGFloat y_scale = _frame.origin.y/last_height;
//    CGFloat width_scale = _frame.size.width/last_width;
//    CGFloat height_scale = _frame.size.height/last_height;
//    
//    CGRect newFrame = CGRectMake(x_scale*width, y_scale*height, width_scale*width, height_scale*height);
//    _self_last_frame = self.view.frame;
//    _frame = newFrame;
//    self.presentController.view.frame = newFrame;
//}

-(void )containerController:(__kindof UIViewController *)controller frame:(CGRect)frame
{
//    _frame = frame;
//    _self_last_frame = self.view.frame;
    self.presentController = controller;
    self.presentController.view.frame = frame;
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
    self.pan.delegate = self;
    [self.presentController.view addGestureRecognizer:self.pan];
    
    if ([self.presentController isKindOfClass:[UINavigationController class]])
    {
        self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_pinch:)];
        [self.presentController.view addGestureRecognizer:self.pinch];
    }
    
    [self addChildViewController:self.presentController];
    [self.view addSubview:self.presentController.view];
}

-(void )dismissContainerController
{
    if (self.presentController == nil)
    {
        return;
    }
    [self.presentController.view removeGestureRecognizer:self.pan];
    [self.pan removeTarget:self action:@selector(_pan:)];
    self.pan = nil;
    
    //add pinch gesture
    if ([self.presentController isKindOfClass:[UINavigationController class]])
    {
        [self.presentController.view removeGestureRecognizer:self.pinch];
        [self.pinch removeTarget:self action:@selector(_pinch:)];
        self.pinch = nil;
    }
    
    [self.presentController.view removeFromSuperview];
    [self.presentController removeFromParentViewController];
}

-(void )_pan:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self.view];
    CGPoint center = self.presentController.view.center;
    CGFloat widthCenter = CGRectGetWidth(self.presentController.view.frame)*0.5;
    CGFloat heightCenter = CGRectGetHeight(self.presentController.view.frame)*0.5;
    
    center.x += point.x;
    center.y += point.y;
    if (center.x - widthCenter + self.edgeLeftOrRight < 0)
    {
        center.x = widthCenter - self.edgeLeftOrRight;
    }
    if (center.x + widthCenter - self.edgeLeftOrRight > CGRectGetWidth(self.view.bounds))
    {
        center.x = CGRectGetWidth(self.view.bounds) - widthCenter + self.edgeLeftOrRight;
    }
    if (center.y - heightCenter < 0)
    {
        center.y = heightCenter;
    }
    if (center.y + heightCenter > CGRectGetHeight(self.view.bounds))
    {
        center.y = CGRectGetHeight(self.view.bounds) - heightCenter;
    }
    self.presentController.view.center = center;
    if (self.moveCallback)
    {
        self.moveCallback();
    }
//    _frame = self.presentController.view.frame;
    [gesture setTranslation:CGPointZero inView:self.view];
}

-(void )_pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state  == UIGestureRecognizerStateBegan)
    {
        _pinch_width = CGRectGetWidth(self.presentController.view.frame);
        _pinch_height = CGRectGetHeight(self.presentController.view.frame);
        _pinch_x = CGRectGetMinX(self.presentController.view.frame);
        _pinch_y = CGRectGetMinY(self.presentController.view.frame);
    }
    CGFloat scale = gesture.scale;
    CGFloat width = _pinch_width * scale;
    CGFloat height = _pinch_height * scale;
    CGRect newFrame = self.presentController.view.frame;
    
    CGFloat halfMoreWidth = (width - _pinch_width)*0.5;
    CGFloat halfMoreHeight = (height - _pinch_height)*0.5;
    
    newFrame.origin.x = _pinch_x - halfMoreWidth * 0.5;
    newFrame.origin.y = _pinch_y - halfMoreHeight * 0.5;
    newFrame.size.width = _pinch_width + halfMoreWidth;
    newFrame.size.height = _pinch_height + halfMoreHeight;
    if (newFrame.origin.x < 0)
    {
        newFrame.origin.x = 0;
    }
    if (newFrame.origin.y < 0)
    {
        newFrame.origin.y = 0;
    }
    if (newFrame.size.width > CGRectGetWidth(self.view.bounds))
    {
        newFrame.size.width = CGRectGetWidth(self.view.bounds);
    }
    if (newFrame.size.height > CGRectGetHeight(self.view.bounds))
    {
        newFrame.size.height = CGRectGetHeight(self.view.bounds);
    }
    if (CGRectGetMaxX(newFrame) > CGRectGetWidth(self.view.bounds))
    {
        newFrame.origin.x = CGRectGetWidth(self.view.bounds) - newFrame.size.width;
    }
    if (CGRectGetMaxY(newFrame) > CGRectGetHeight(self.view.bounds))
    {
        newFrame.origin.y = CGRectGetHeight(self.view.bounds) - newFrame.size.height;
    }
    self.presentController.view.frame = newFrame;
//    _frame = self.presentController.view.frame;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    NSLog(@"now:%@",gestureRecognizer.view.class);
//    NSLog(@"other:%@",otherGestureRecognizer.view.class);
    if ([NSStringFromClass(otherGestureRecognizer.view.class) isEqualToString:@"UITableViewWrapperView"])
    {
        return YES;
    }
    return NO;
}

@end
