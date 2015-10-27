//
//  BookDetailController.m
//  DCXXSystem
//
//  Created by teddy on 15/8/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "BookDetailController.h"
#import "SelectTimeCell.h"
#import "LIstViewController.h"

#define ButtonHeight 30
#define ButtonWidth 280

@interface BookDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    
    
    NSString *_startTime; //开始时间
    NSString *_endTime;//结束时间
    NSString *_machineType; //投影仪类别
}

@end

@implementation BookDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BG_COLOR;
    self.title = @"预定选项";
    [self initBar];
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,(kScreen_height/5)*3} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmBtn.frame = (CGRect){(kScreen_Width - ButtonWidth)/2,_tableView.frame.size.height + 10,ButtonWidth,ButtonHeight};
    comfirmBtn.titleLabel.textColor = [UIColor blackColor];
    [comfirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    comfirmBtn.backgroundColor = [UIColor colorWithRed:25/255.0 green:110/255.0 blue:241/255.0 alpha:1.0];
    comfirmBtn.layer.cornerRadius = 5.0f;
    [comfirmBtn addTarget:self action:@selector(comfirmMeetingRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfirmBtn];
}

- (void)initBar
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem= back;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)comfirmMeetingRoomAction:(id)sender
{
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;//开始时间和结束时间
            break;
        case 1:
            return 1; //已预约时间段
            break;
        case 2:
            return 1;//是否需要投影仪
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            SelectTimeCell *cell = (SelectTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"selectTimeCell" owner:nil options:nil] lastObject];
            if (indexPath.row == 0) {
                cell.ttitleLabel.text = @"开始时间";
                cell.valueLabel.text = @"8:30";
            }else{
                cell.ttitleLabel.text = @"结束时间";
                cell.valueLabel.text = @"9:00";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"已经预约时段";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        case 2:
        {
            SelectTimeCell *cell = (SelectTimeCell *)[[[NSBundle mainBundle] loadNibNamed:@"selectTimeCell" owner:nil options:nil] lastObject];
            cell.ttitleLabel.text = @"是否需要投影仪";
            cell.valueLabel.text = @"不需要";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            
            SelectTimeCell *cell = (SelectTimeCell *)[tableView cellForRowAtIndexPath:indexPath];
            LIstViewController *list = [[LIstViewController alloc] init];
            list.index = 1;
            list.title = cell.ttitleLabel.text;
            [list setSelectBlock:^(NSString *selectedStr) {
                if (indexPath.row == 0) {
                    //开始时间
                    _startTime = selectedStr;
                }else{
                    //结束时间
                    _endTime = selectedStr;
                }
                cell.valueLabel.text = selectedStr;
            }];
            [self.navigationController pushViewController:list animated:YES];

        }
            break;
        case 1:
        {
            //已预约的时间段
            UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            LIstViewController *list = [[LIstViewController alloc] init];
            list.index = 3;
            list.title = cell.textLabel.text;
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 2:
        {
            //是否需要投影仪
            SelectTimeCell *cell = (SelectTimeCell *)[tableView cellForRowAtIndexPath:indexPath];
            LIstViewController *list = [[LIstViewController alloc] init];
            list.index = 4;
            list.title = cell.ttitleLabel.text;
            [list setSelectBlock:^(NSString *selectedStr) {
                //结束时间
                cell.valueLabel.text = selectedStr;
                _machineType = selectedStr;
            }];
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
