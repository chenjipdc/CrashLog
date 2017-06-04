//
//  RSCrashShowViewController.m
//  RSDebugCrash
//
//  Created by pdc on 2017/5/27.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashShowViewController.h"
#import "RSCrashRead.h"

@interface RSCrashShowViewController ()
@property (nonatomic, strong) UITextView *textView;

@end

@implementation RSCrashShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    self.textView.selectable = YES;
    [self.view addSubview:self.textView];
    self.textView.text = self.crashLog;
}

-(void )viewDidLayoutSubviews
{
    self.textView.frame = self.view.bounds;
}

@end
