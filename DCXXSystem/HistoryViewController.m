//
//  HistoryViewController.m
//  DCXXSystem
//
//  Created by teddy on 15/8/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "HistoryViewController.h"
#import "SVProgressHUD.h"
#import "RequestObject.h"
#import "HistoryCell.h"
#import "HeaderView.h"
#import "MyTimeView.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table; //右侧列表
    NSArray *_list; //右侧列表数据源
    
    NSArray *_headers;//列表头部label数组
    NSMutableArray *_stations;//左侧列表的数据源
    NSUInteger _kCount;
}

@property (nonatomic, strong) UIView *myHeaderView;

@property (nonatomic, strong) MyTimeView *myTimeView;
@end

@implementation HistoryViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [RequestObject cancelRequest];
        [SVProgressHUD dismiss];
    }
}

- (void)initData
{
    _headers = @[@"会议室名称",@"预约时间",@"预约部门",@"是否需投影"];
    _kCount = _headers.count;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"预定记录";
    self.view.backgroundColor = BG_COLOR;
    
    [self initData];
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:(CGRect){0,0,_kCount*kWidth, kHeight}];
    tableViewHeader.backgroundColor = BG_COLOR;
    self.myHeaderView = tableViewHeader;
    
    for (int i=0; i<_kCount; i++) {
        HeaderView *header = [[HeaderView alloc] initWithFrame:(CGRect){i*kWidth,0,kWidth,kHeight}];
        header.num = _headers[i];
        [tableViewHeader addSubview:header];
    }
    
    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.myHeaderView.frame.size.width,kScreen_height} style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.bounces = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth, 0,kScreen_Width - kWidth , kScreen_height)];
    [scrollView addSubview:_table];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.myHeaderView.frame.size.width, 0);
    [self.view addSubview:scrollView];
    
    self.myTimeView = [[MyTimeView alloc] initWithFrame:(CGRect){0,44,kWidth,kScreen_height}];
    self.myTimeView.listData = _stations;
    self.myTimeView.headTitle = @"预定时间";
    [self.view addSubview:self.myTimeView];
    
    //加载网络数据
    [self requestHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
            [_table setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

#pragma mark - Private Method
- (void)requestHttp
{
    NSDictionary *user = [self getUser];
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([RequestObject fetchWithType:@"GetMyMBooking" withResults:[user objectForKey:@"Sid"]]) {
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
    dispatch_async(dispatch_get_main_queue(), ^{
        _list = [RequestObject requestData];
        if (_list.count != 0) {
            [SVProgressHUD dismissWithSuccess:@"加载成功"];
            _stations =[NSMutableArray arrayWithCapacity:_list.count];
            for (NSDictionary *dic in _list) {
                [_stations addObject:[dic objectForKey:@"Sdatetime"]];
            }
            [self.myTimeView refrushTableView:_stations];
            [_table reloadData];
        }else{
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求的网络数据为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
#pragma mark - UITableVIewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"Mycell"];
    if (cell == nil) {
        cell = (HistoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dic = _list[indexPath.row];
    cell.meetingRoomName.text = [dic objectForKey:@"Sname"];
    cell.bookTimeLabel.text = [NSString stringWithFormat:@"%@   %@",[dic objectForKey:@"Sam"],[dic objectForKey:@"Spm"]];
    cell.departmentLabel.text = [dic objectForKey:@"DeptName"];
    cell.machineLabel.text = [dic objectForKey:@"Sprojector"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.myHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return kHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
#endif
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetY = _table.contentOffset.y;
    
    CGPoint timeOffSet = self.myTimeView.myTableView.contentOffset;
    
    timeOffSet.y = offSetY;
    self.myTimeView.myTableView.contentOffset = timeOffSet;
    
    if (offSetY == 0) {
        self.myTimeView.myTableView.contentOffset = CGPointZero;

    }
}
@end
