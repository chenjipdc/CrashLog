//
//  RSCrashDeviceViewController.m
//  CrashLogDemo
//
//  Created by pdc on 2017/6/4.
//  Copyright © 2017年 RealsCloud. All rights reserved.
//

#import "RSCrashDeviceViewController.h"
#import "RSCrashRead.h"

@interface RSDeviceSplitModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@end

@implementation RSDeviceSplitModel
+(instancetype )deviceSplitModelWithName:(NSString *)name value:(NSString *)value
{
    RSDeviceSplitModel *model = [RSDeviceSplitModel new];
    model.name = name;
    model.value = value;
    return model;
}

@end

@interface RSCrashDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RSCrashRead *crashRead;

@property (nonatomic, strong) RSDeviceModel *deviceModel;

@property (nonatomic, strong) NSArray<RSDeviceSplitModel *> *splitDeviceModel;
@end

@implementation RSCrashDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
    __weak typeof(self) weakSelf = self;
    self.crashRead = [RSCrashRead new];
    [self.crashRead readDeviceData:^(RSDeviceModel *deviceModel) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.deviceModel = deviceModel;
        [strongSelf _spliteDeviceModel];
    }];
}

-(void )_spliteDeviceModel
{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[RSDeviceSplitModel deviceSplitModelWithName:@"name" value:self.deviceModel.name]];
    [arr addObject:[RSDeviceSplitModel deviceSplitModelWithName:@"model" value:self.deviceModel.model]];
    [arr addObject:[RSDeviceSplitModel deviceSplitModelWithName:@"localizedModel" value:self.deviceModel.localizedModel]];
    [arr addObject:[RSDeviceSplitModel deviceSplitModelWithName:@"systemName" value:self.deviceModel.systemName]];
    [arr addObject:[RSDeviceSplitModel deviceSplitModelWithName:@"systemVersion" value:self.deviceModel.systemVersion]];
    [arr addObject:[RSDeviceSplitModel deviceSplitModelWithName:@"uuid" value:self.deviceModel.uuid]];
    [arr addObject:[RSDeviceSplitModel deviceSplitModelWithName:@"appVersion" value:self.deviceModel.appVersion]];
    self.splitDeviceModel = [arr copy];
    [self.tableView reloadData];
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
    return self.splitDeviceModel.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    RSDeviceSplitModel *splitModel = self.splitDeviceModel[indexPath.row];
    cell.textLabel.text = splitModel.name;
    cell.detailTextLabel.text = splitModel.value;
    return cell;
}
@end
