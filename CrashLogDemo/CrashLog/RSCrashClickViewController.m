//
//  RSCrashClickViewController.m
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashClickViewController.h"

@interface RSCrashClickViewController ()
@property (nonatomic, strong) UIButton *button;

@end

@implementation RSCrashClickViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor purpleColor];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.view = self.button;
    
    [self.button setTitle:@"log" forState:UIControlStateNormal];
    
    [self.button addTarget:self action:@selector(_click:) forControlEvents:UIControlEventTouchUpInside];
}

-(void )viewDidLayoutSubviews
{
    CGSize size = self.view.frame.size;
    self.view.layer.cornerRadius = size.width * 0.5;
}

-(void )_click:(UIButton *)sender
{
    if (self.clickAction)
    {
        self.clickAction();
    }
}

@end
