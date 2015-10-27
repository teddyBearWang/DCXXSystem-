//
//  CountDetailController.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CountDetailController.h"
#import "SVProgressHUD.h"
#import "PersonDetailController.h"
#import "RequestObject.h"

@interface CountDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSArray *listData;
}

@end

@implementation CountDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [RequestObject cancelRequest];
        [SVProgressHUD dismiss];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详情";
    
    self.view.backgroundColor = BG_COLOR;
    
    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    [self getWebData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
   // NSString *result = [self.restaurantName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"TotalBookingView" withResults:self.restaurantName]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //请求失败
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        listData = [RequestObject requestData];
        if (listData.count != 0) {
            [_table reloadData];
        }
    });
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = listData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@份",[dic objectForKey:@"type"],[dic objectForKey:@"value"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonDetailController *personCtrl = [[PersonDetailController alloc] init];
    personCtrl.dic = listData[indexPath.row];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    [self.navigationController pushViewController:personCtrl animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
