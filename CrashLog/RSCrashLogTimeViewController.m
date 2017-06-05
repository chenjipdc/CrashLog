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
#import "RSCrashDelete.h"

@interface RSCrashLogTimeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RSCrashDelete *crashDelete;
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

-(RSCrashDelete *)crashDelete
{
    if (_crashDelete == nil)
    {
        _crashDelete = [RSCrashDelete new];
    }
    return _crashDelete;
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        RSLogTimeModel *model = weakSelf.datas[indexPath.row];
        [weakSelf.crashDelete deleteRecordWithLogTimeId:model.logTimeId state:^(BOOL state) {
            if (state)
            {
                [weakSelf.datas removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
        }];
    }];
    return @[deleteAction];
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
