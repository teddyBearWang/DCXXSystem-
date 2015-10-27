//
//  PeopleSelectController.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PeopleSelectController.h"
#import "SVProgressHUD.h"
#import "PeopleDetailController.h"
#import "RequestObject.h"

@interface PeopleSelectController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;//数据源
}
@property (strong, nonatomic)  UITableView *companyTableView;

@end

@implementation PeopleSelectController

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
    
    self.title = @"组织架构";
    
    self.companyTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    self.companyTableView.delegate = self;
    self.companyTableView.dataSource = self;
    [self.view addSubview:self.companyTableView];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    [self getWebData];
    //(234,86,14)
//    self.navigationBar.barTintColor = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:1.0];
//    self.navigationBar.tintColor = [UIColor whiteColor];//返回按钮颜色
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//修改标题颜色
//    
//    UIButton *canel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    canel_btn.frame = (CGRect){0,0,40,25};
//    [canel_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [canel_btn setTitle:@"取消" forState:UIControlStateNormal];
//    [canel_btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UINavigationItem *item = [[UINavigationItem alloc] init];
//    [self.navigationBar pushNavigationItem:item animated:YES];
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:canel_btn];
//    item.leftBarButtonItem = left;
    
}
//取消
//- (void)cancelAction:(UIButton *)button
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"GetDept" withResults:@"0$"]) {
           // [PeopleObject fetch:@"" withLevel:@"0"];
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
            [self.companyTableView reloadData];
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [listData[indexPath.row] objectForKey:@"Sname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PeopleDetailController *detail = [[PeopleDetailController alloc] init];
    detail.title = [listData[indexPath.row] objectForKey:@"Sname"];
    detail.sid = [listData[indexPath.row] objectForKey:@"Sid"];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
