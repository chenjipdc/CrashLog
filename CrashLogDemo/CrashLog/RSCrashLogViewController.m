//
//  RSCrashLogViewController.m
//  RSCrashCrash
//
//  Created by pdc on 2017/5/26.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashLogViewController.h"
#import "RSCrashLogTimeViewController.h"
#import "RSCrashDeviceViewController.h"
#import "RSCrashRead.h"
#import "RSCrashDelete.h"

@interface RSCrashLogViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RSCrashDelete *crashDelete;
@property (nonatomic, strong) RSCrashRead *crashRead;
@property (nonatomic, strong) NSMutableArray<RSLogDateModel *> *datas;

@end

@implementation RSCrashLogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"device" style:UIBarButtonItemStylePlain target:self action:@selector(_showDeviceInfo:)];
    
    // Do any additional setup after loading the view.
    [self _createSubViews];
    [self _loadMore];
}

-(void )viewDidLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
}

-(void )_createSubViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

-(void )_loadMore
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
    [self.crashRead readDateLogWithIndex:0 max:999 data:^(NSInteger total, NSArray<RSLogDateModel *> *logDates) {
        [weakSelf.datas addObjectsFromArray:logDates];
        [weakSelf.tableView reloadData];
    }];
}

-(void )_showDeviceInfo:(id )sender
{
    [self.navigationController pushViewController:[RSCrashDeviceViewController new] animated:YES];
}

-(RSCrashDelete *)crashDelete
{
    if (_crashDelete == nil)
    {
        _crashDelete = [RSCrashDelete new];
    }
    return _crashDelete;
}

#pragma mark - tableView delegate datasource
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
        RSLogDateModel *model = weakSelf.datas[indexPath.row];
        [weakSelf.crashDelete deleteRecordWithLogDateId:model.logDateId state:^(BOOL state) {
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
    RSLogDateModel *model = self.datas[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.date];
    return cell;
}

-(void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RSCrashLogTimeViewController *controller = [RSCrashLogTimeViewController new];
    controller.model = self.datas[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
