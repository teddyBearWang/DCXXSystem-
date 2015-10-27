//
//  PeopleDetailController.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PeopleDetailController.h"
//#import "PeopleObject.h"
#import "SVProgressHUD.h"
#import "RequestObject.h"

@interface PeopleDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *listData;
    NSDictionary *_selectUser;//选中的人
}

@end

@implementation PeopleDetailController

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
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BG_COLOR;
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        confirm.frame = (CGRect){0,0,40,25};
    
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setTitle:@"确定" forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:14];
        [confirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];

    
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:confirm];
        self.navigationItem.rightBarButtonItem = left;
    
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
    NSString *resluts = [NSString stringWithFormat:@"1$%@",self.sid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"GetDept" withResults:resluts]) {
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
            [_tableView reloadData];
        }
    });
}

//同步到本地
- (void)confirmAction:(UIButton *)btn
{
    if ([(NSString *)[_selectUser objectForKey:@"Sname"] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一个人" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_selectUser forKey:USERNAME];
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [listData[indexPath.row] objectForKey:@"Sname"];
    return cell;
}

static NSInteger _selectRow;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectRow >= 0) {
        //取消上一次选中
        NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:_selectRow inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldIndex];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _selectUser = listData[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectRow = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
