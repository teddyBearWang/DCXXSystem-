//
//  PersonDetailController.m
//  DCXXSystem
//  ***********订餐人员详情***********
//  Created by teddy on 15/8/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PersonDetailController.h"
#import "RequestObject.h"
#import "SVProgressHUD.h"
#import "PersonCountCell.h"

@interface PersonDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSArray *_list;//数据源
    BOOL _isHasPermission;//是否权限
}

@end

@implementation PersonDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [self.dic objectForKey:@"type"];
    
    self.view.backgroundColor = BG_COLOR;
    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [users objectForKey:USERNAME];
    NSString *name = (NSString *)[dict objectForKey:@"Sname"];
    if ([name isEqualToString:@"汪超"]) {
        _isHasPermission = YES;
    }
    
    [self requestHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Method

- (void)requestHttp
{
   // http://115.236.2.245:38019/DataDc.ashx?t=TotalBookingView2&results=72$
    [SVProgressHUD showErrorWithStatus:@"加载中.."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"TotalBookingView2" withResults:[NSString stringWithFormat:@"%@$%@",[self.dic objectForKey:@"sid"],[self.dic objectForKey:@"sname"]]]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI
        _list = [RequestObject requestData];
        if (_list.count != 0) {
            [_table reloadData];
        }
    });
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"cell";
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    
//    }
//    NSDictionary *dic = _list[indexPath.row];
//    UILabel *dateLabel = (UILabel *)[self.view viewWithTag:101];
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.text = [dic objectForKey:@"value"];
//    return cell;
    PersonCountCell *cell = (PersonCountCell *)[[[NSBundle mainBundle] loadNibNamed:@"PersonCell" owner:nil options:nil] lastObject];
    NSDictionary *dic = _list[indexPath.row];
    cell.personNameLabel.text = [dic objectForKey:@"value"];
    if (_isHasPermission) {
        cell.dateLabel.text = [dic objectForKey:@"type"];
        cell.dateLabel.hidden = NO;//显示
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
