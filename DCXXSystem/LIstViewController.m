//
//  LIstViewController.m
//  DCXXSystem
//
//  Created by teddy on 15/8/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LIstViewController.h"

@interface LIstViewController ()<UITableViewDataSource ,UITableViewDelegate>
{
    UITableView *_tableView;
    //NSArray *_sourceData;//数据源

}

@end

@implementation LIstViewController
//@synthesize sourceData = _sourceData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    switch (self.index) {
        case 1:
        {
            //上午时间
            self.sourceData = @[@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00"];
        }
            break;
        case 2:
        {
            //下午时间
            self.sourceData = @[@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00"];
        }
            break;
        case 3:
        {
            //已被预约时段
            self.sourceData = @[@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00"];
        }
            break;
        case 4:
        {
           self.sourceData = @[@"不需要",@"大投影仪",@"小投影仪"]; 
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
         return self.sourceData.count;
    }
    @catch (NSException *exception) {
        NSLog(@"错误：%@",exception);
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.sourceData[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *select_str = self.sourceData[indexPath.row];
    self.selectBlock(select_str);
    
    //回到上一级
    [self.navigationController popViewControllerAnimated:YES];
}

@end
