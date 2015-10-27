//
//  OrderDetailController.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "OrderDetailController.h"
#import "SVProgressHUD.h"
#import "RequestObject.h"

@interface OrderDetailController ()<UIAlertViewDelegate>
{
    NSArray *resposeArr;//返回结果
    BOOL _isOK;//操作成功
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)comfirmOrderAction:(id)sender;

- (IBAction)cancelAction:(id)sender;
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cancelBtn.layer.cornerRadius = 4.0f;
    self.comfirmBtn.layer.cornerRadius = 4.0f;
    

    @try {
        NSDictionary *user = [self getUser];
        NSString *name = (NSString *)[user objectForKey:@"Sname"];
        if ([name length] == 0) {
            self.nameLabel.text = @"未知用户";
        }else{
            self.nameLabel.text = [NSString stringWithFormat:@"姓       名: %@",name];
        }
        self.dateLabel.text = [NSString stringWithFormat:@"预定日期: %@",[self getSystemDate]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    if (self.isCanBook) {
        //不能订餐
        self.comfirmBtn.userInteractionEnabled = NO;
        [self.comfirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        self.cancelBtn.userInteractionEnabled = NO;
        [self.cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];

    
}

//获取用户
- (NSDictionary *)getUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [defaults objectForKey:USERNAME];
    return user;
}

- (NSString *)getSystemDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date_str = [formatter stringFromDate:now];
    return date_str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获取网络数据
- (void)getWeb:(NSString *)result withType:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:type withResults:result]) {
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
        resposeArr = [RequestObject requestData];
        NSDictionary *resResult = [resposeArr lastObject];
        if ([[resResult objectForKey:@"success"] isEqualToString:@"true"]) {
            _isOK = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[resResult objectForKey:@"result"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            _isOK = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[resResult objectForKey:@"result"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
}


//确认订餐
- (IBAction)comfirmOrderAction:(id)sender
{
    NSDictionary *user = [self getUser];
    NSString *result = [NSString stringWithFormat:@"%@$%@",[user objectForKey:@"Sid"],self.restaurantId];
    
    [self getWeb:result withType:@"IntBooking"];
  
}

//取消订餐
- (IBAction)cancelAction:(id)sender
{
     NSDictionary *user = [self getUser];
     [self getWeb:[user objectForKey:@"Sid"] withType:@"CanelBooking"];
 
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_isOK) {
        if (buttonIndex == 0) {
            _isOK = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


@end
