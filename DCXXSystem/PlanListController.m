//
//  PlanListController.m
//  DCXXSystem
//
//  Created by teddy on 15/8/11.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PlanListController.h"
#import "SVProgressHUD.h"
#import "RequestObject.h"
#import "FIleDownLoad.h"
#import "PDFViewController.h"

@interface PlanListController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_list;//数据源
}

@end

@implementation PlanListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.dic objectForKey:@"Sname"];
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view  addSubview:_tableView];
    
    //注册两个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileDownloadComplete:) name:FILEDOWNLOADCOMPLETE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileDownloadFail:) name:FILEDOWNLOADFAIL object:nil];
    
    [self requestHttp];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - privateMethod
- (void)requestHttp
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *result = [NSString stringWithFormat:@"name$1$%@",[self.dic objectForKey:@"Sid"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"GetFxPlanTree" withResults:result]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //加载失败
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
            [_tableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无预案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
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
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = _list[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [dic objectForKey:@"Sname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _list[indexPath.row];
    if ([[dic objectForKey:@"PlanUrl"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无效的地址" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self downPDFFile:[dic objectForKey:@"PlanUrl"]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 下载PDF

- (void)downPDFFile:(NSString *)url
{
    FIleDownLoad *downloadFile = [FIleDownLoad shareTheme];
    [SVProgressHUD showWithStatus:@"下载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加载
        [downloadFile downloadFileWithUrl:url];
    });
}

//下载成功
- (void)FileDownloadComplete:(NSNotification *)notification
{
    [SVProgressHUD dismissWithSuccess:@"下载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI
        NSString *filePath = notification.object;
        //push到下个界面
        PDFViewController *reader = [[PDFViewController alloc] init];
        reader.pdfName = filePath;
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"返回";
        self.navigationItem.backBarButtonItem = back;
        [self.navigationController pushViewController:reader animated:YES];
    });
}

- (void)FileDownloadFail:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithError:@"下载失败"];
    });
}

@end
