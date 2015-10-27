//
//  RestaurantViewController.m
//  DCXXSystem
//  ***********餐厅选择*************
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RestaurantViewController.h"
#import "OrderDetailController.h"
#import "SVProgressHUD.h"
#import "ResturantCell.h"
#import "RequestObject.h"

@interface RestaurantViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *list;//数据源
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RestaurantViewController

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
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
   // list = @[@"英群小吃",@"华必堡餐厅"];
    [self getWebData];
    
}

//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"GetRefectory" withResults:self.personId]) {
            //[RestaurantObject fetchWithPersonID:self.personId]
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
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无餐厅" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil
                                  , nil];
            [alert show];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    
    ResturantCell *cell = (ResturantCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ResturantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:(CGRect){240,12,50,20}];
        statusLabel.tag = 101;
        statusLabel.font = [UIFont systemFontOfSize:14];
        [statusLabel setTextColor:[UIColor redColor]];
        [cell.contentView addSubview:statusLabel];
    }
    UILabel *status = (UILabel *)[cell viewWithTag:101];
    NSDictionary *restaurant = list[indexPath.row];
    if ([[restaurant objectForKey:@"Szt"] isEqualToString:@"true"]) {
        //status.backgroundColor = [UIColor greenColor];
        status.text = @"已预定";
        cell.isBook = YES;
    }else{
        cell.isBook = NO;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [restaurant objectForKey:@"Sname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResturantCell *cell = (ResturantCell *)[tableView cellForRowAtIndexPath:indexPath];
    OrderDetailController *order = [[OrderDetailController alloc] initWithNibName:@"OrderDetailController" bundle:nil];
    order.title = [list[indexPath.row] objectForKey:@"Sname"];
    order.restaurantId = [list[indexPath.row] objectForKey:@"Sid"];
    order.isCanBook = cell.isBook;//传递进去是否能订餐的状态
    [self.navigationController pushViewController:order animated:YES];
}

@end
