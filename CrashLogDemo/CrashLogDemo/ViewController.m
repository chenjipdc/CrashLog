//
//  ViewController.m
//  CrashLogDemo
//
//  Created by pdc on 2017/6/1.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
-(void )log;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)crash:(id)sender
{
//    char *p = (char *)-1;
//    *p = 1;
    
//    id data = [NSArray arrayWithObject:@"Hello World"];
//    [(NSDictionary*)data objectForKey:@""];
    
    [self log];
    
//    abort();
    
    NSArray *arr = @[];
    NSLog(@"%@",arr[10]);
}

@end
