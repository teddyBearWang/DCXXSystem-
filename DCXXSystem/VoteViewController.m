//
//  VoteViewController.m
//  DCXXSystem
//  *************投票***********
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VoteViewController.h"
#import "RequestObject.h"
#import "SVProgressHUD.h"
#import "VoteCell.h"

@interface VoteViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_list;//数据源
    NSString *_selectItem;//反对或者赞成
    NSString *_selectTid;//选择的tid
    BOOL _isVote;//是否投票
    NSString *_personID;//用户编号
    int _selectSection;//选择的行数
    BOOL _ishasPermission;//是否有权限
}

@property (weak, nonatomic) IBOutlet UITableView *voteTable;
@end

@implementation VoteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //加载网络
    [self getWebDataWithRequestType:@"GetVote" results:_personID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.voteTable.delegate = self;
    self.voteTable.dataSource = self;
    self.voteTable.backgroundColor = BG_COLOR;
    self.view.backgroundColor = BG_COLOR;
    
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [users objectForKey:USERNAME];
    _personID = [dict objectForKey:@"Sid"];
    NSString *name = (NSString *)[dict objectForKey:@"Sname"];
    if ([name isEqualToString:@"郑毅"] || [name isEqualToString:@"王昂峰"]|| [name isEqualToString:@"汪超"]) {
        _ishasPermission = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(addCallVoteAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = left;
    }
}

#pragma mark - WebDataAction
- (void)getWebDataWithRequestType:(NSString *)type results:(NSString *)result
{
    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:type withResults:result]) {
            //更新主界面
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
        NSArray *list = [RequestObject requestData];
        if (list.count != 0) {
            if (!_isVote) {
                [SVProgressHUD dismissWithSuccess:@"加载成功"];
                _list = [NSMutableArray arrayWithArray:list];
                [self.voteTable reloadData];
            }else{
                //投票返回
                _isVote = NO;
                [SVProgressHUD dismissWithSuccess:[list[0] objectForKey:@"result"]];
                if ([[list[0] objectForKey:@"success"] isEqualToString:@"true"]) {
                    //成功
                    NSDictionary *dict = _list[_selectSection];
                    [dict setValue:@"1" forKey:@"VoteRes"];
                    if ([_selectItem isEqualToString:@"1"]) {
                        //点击了赞同按钮
                        int count = [[dict objectForKey:@"OkCount"] intValue];
                        count = count + 1;//自动加1
                        [dict setValue:[NSString stringWithFormat:@"%d",count] forKey:@"OkCount"];
                    }else{
                        //点击了取消按钮
                        int count = [[dict objectForKey:@"NoOkCount"] intValue];
                        count = count + 1;//自动加1
                        [dict setValue:[NSString stringWithFormat:@"%d",count] forKey:@"NoOkCount"];
                    }
                }
                [self.voteTable reloadData];
            }

        }else{
            [SVProgressHUD dismissWithSuccess:@"当前无数据"];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击添加按钮的操作
- (void)addCallVoteAction:(UIButton *)button
{
    //发起投票
    [self performSegueWithIdentifier:@"callVote" sender:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoteCell *cell = (VoteCell *)[[[NSBundle mainBundle] loadNibNamed:@"VoteCell" owner:nil options:nil] lastObject];
    //添加投票事件
    [cell.approvalBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.aginstBtn addTarget:self action:@selector(voteAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_ishasPermission) {
        //对删除按钮添加删除事件
        [cell.closeBtn addTarget:self action:@selector(closeVoteAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.closeBtn.tag = indexPath.section;
    }
    cell.approvalBtn.tag = indexPath.section;
    cell.aginstBtn.tag = indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = _list[indexPath.section];
    [cell setContentName:dict withPermission:_ishasPermission];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//投票
- (void)voteAction:(UIButton *)btn
{
    _selectSection = (int)btn.tag;//选择的section
    NSString *message = nil;
    if ([btn.currentTitle isEqualToString:@"赞成"]) {
        //点击了赞成按钮
        NSLog(@"赞同");
        _selectItem = @"1";
       message = [NSString stringWithFormat:@"您要对 \"%@\" 投赞同票",[_list[btn.tag] objectForKey:@"Title"]];
    }else{
        //点击了反对按钮
         NSLog(@"反对");
        _selectItem = @"0";
       message = [NSString stringWithFormat:@"您要对 \"%@\" 投反对票",[_list[btn.tag] objectForKey:@"Title"]];
    }
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    _selectTid= [_list[btn.tag] objectForKey:@"Tid"];
  
}

//删除
- (void)closeVoteAction:(UIButton *)button
{
    NSDictionary *dict = _list[button.tag];
    //[self getWebDataWithRequestType:@"ShutVote" results:_selectTid];
    [SVProgressHUD showWithStatus:@"正在关闭投票"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"ShutVote" withResults:[dict objectForKey:@"Tid"]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *list = [RequestObject requestData];
                if (list.count != 0) {
                    NSDictionary *dict = [list objectAtIndex:0];
                    if ([[dict objectForKey:@"success"] isEqualToString:@"true"]) {
                        [SVProgressHUD dismissWithSuccess:[dict objectForKey:@"result"]];
                        [_list removeObjectAtIndex:button.tag];
                        [self.voteTable reloadData];
                    }else{
                        [SVProgressHUD dismissWithError:[dict objectForKey:@"result"]];
                    }
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"关闭失败"];
            });
        }
    });
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //确定投票
        NSString *result = [NSString stringWithFormat:@"%@$%@$%@",_personID,_selectTid,_selectItem];
        [self getWebDataWithRequestType:@"IntVote" results:result];
        _isVote = YES;
    }
}

@end
