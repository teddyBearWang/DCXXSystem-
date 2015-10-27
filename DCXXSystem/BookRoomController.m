//
//  BookRoomController.m
//  DCXXSystem
//  ***********会议室预定*******
//  Created by teddy on 15/8/11.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BookRoomController.h"
#import "RequestObject.h"
#import "SVProgressHUD.h"
#import "MeetingBookDetailController.h"
#import "HistoryViewController.h"

@interface BookRoomController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_list; //数据源
}
@property (weak, nonatomic) IBOutlet UITableView *meetTable;

@end

@implementation BookRoomController

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
    
    self.title = @"会议室列表";
    self.view.backgroundColor = BG_COLOR;
    self.meetTable.delegate = self;
    self.meetTable.dataSource = self;
    
    [self initBar];
    
    [self requestHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBar
{
    UIButton *update_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    update_btn.frame = (CGRect){0,0,60,20};
    update_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    update_btn.titleLabel.textColor = [UIColor whiteColor];
    [update_btn setTitle:@"预定情况" forState:UIControlStateNormal];
    [update_btn addTarget:self action:@selector(bookedCountAction) forControlEvents:UIControlEventTouchUpInside];
    update_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    update_btn.layer.borderWidth = 0.5;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:update_btn];
    self.navigationItem.rightBarButtonItem = right;
}

//我的预定
- (void)bookedCountAction
{
    HistoryViewController *history = [[HistoryViewController alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    [self.navigationController pushViewController:history animated:YES];
}
#pragma mark - Private Method

- (void)requestHttp
{
    //http://115.236.2.245:38019/DataDc.ashx?t=GetMetting&results=2004
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSDictionary *user = [self getUser];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"GetMetting" withResults:[user objectForKey:@"Sid"]]) {
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
        _list = [RequestObject requestData];
        if (_list.count != 0) {
            [self.meetTable reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取到的数据为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
}

//获取用户
- (NSDictionary *)getUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [defaults objectForKey:USERNAME];
    return user;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = _list[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(容量:%@人)",[dic objectForKey:@"Sname"],[dic objectForKey:@"Scount"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MeetingBookDetailController *meeting = [[MeetingBookDetailController alloc] init];
    meeting.dic = _list[indexPath.row];
    [self.navigationController pushViewController:meeting animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
