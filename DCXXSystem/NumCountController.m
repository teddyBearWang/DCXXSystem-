//
//  NumCountController.m
//  DCXXSystem
//  ***********数量统计**********
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "NumCountController.h"
#import "SVProgressHUD.h"
#import "CountDetailController.h"
#import "RequestObject.h"

@interface NumCountController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *list;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NumCountController

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
    
    self.title = @"订餐统计";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self getWebData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getSystemDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_str = [formatter stringFromDate:now];
    return date_str;
}

//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    //[CountObject fetchWithType:@"TotalBooking" withResult:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"TotalBooking" withResults:[self getSystemDate]]) {
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
        list = [RequestObject requestData];
        if (list.count != 0) {
            [self.myTableView reloadData];
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = list[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@份",[dic objectForKey:@"RefName"],[dic objectForKey:@"Count"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = list[indexPath.row];
    CountDetailController *count = [[CountDetailController alloc] init];
    count.title = [dic objectForKey:@"RefName"];
    count.restaurantName = [dic objectForKey:@"RefName"];
    [self.navigationController pushViewController:count animated:YES];
}

@end
