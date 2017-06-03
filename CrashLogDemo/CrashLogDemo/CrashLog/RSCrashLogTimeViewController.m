//
//  RSCrashLogTimeViewController.m
//  RSDebugCrash
//
//  Created by pdc on 2017/6/1.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashLogTimeViewController.h"
#import "RSCrashShowViewController.h"
#import "RSCrashRead.h"

@interface RSCrashLogTimeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RSCrashRead *crashRead;
@property (nonatomic, strong) NSMutableArray<RSLogTimeModel *> *datas;
@end

@implementation RSCrashLogTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self loadMore];
}

-(void )loadMore
{
    if (self.crashRead == nil)
    {
        self.crashRead = [RSCrashRead new];
    }
    if (self.datas == nil)
    {
        self.datas = [NSMutableArray array];
    }
    __weak typeof(self) weakSelf = self;
    [self.crashRead readTimeLogWithIndex:0 max:999 logDateId:self.model.logDateId data:^(NSInteger total, NSArray<RSLogTimeModel *> *logTimes) {
        [weakSelf.datas addObjectsFromArray:logTimes];
        [weakSelf.tableView reloadData];
    }];
}

-(void )viewDidLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
}


-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    RSLogTimeModel *model = self.datas[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.time];
    return cell;
}

-(void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RSLogTimeModel *model = self.datas[indexPath.row];
    RSCrashShowViewController *controller = [RSCrashShowViewController new];
    controller.crashLog = model.crashLog;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
