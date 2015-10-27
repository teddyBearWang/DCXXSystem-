//
//  ViewController.m
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ViewController.h"
#import "PeopleSelectController.h"
#import "RestaurantViewController.h"
#import "SVProgressHUD.h"
#import "RequestObject.h"

@interface ViewController ()<UIAlertViewDelegate>
{
    NSString *_url;
}

@property (weak, nonatomic) IBOutlet UIButton *reserve_btn;
@property (weak, nonatomic) IBOutlet UIButton *count_btn;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

//@property (weak, nonatomic) IBOutlet UILabel *fontLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
//人员选择
- (IBAction)selectPeopleAction:(id)sender;
//订餐
- (IBAction)bookAction:(id)sender;
//预定会议室
- (IBAction)bookMeetingRoomAction:(id)sender;
//视频播放
- (IBAction)playVideoAction:(id)sender;
//投票
- (IBAction)voteAction:(id)sender;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *user = [self getUserName];
    NSString *name = (NSString *)[user objectForKey:@"Sname"];
    if ([name length] == 0) {
        self.userLabel.text = @"未知用户";
    }else{
        self.userLabel.text = name;
    }    
}

//获取保存在本地的信息
- (NSDictionary *)getUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [defaults objectForKey:USERNAME];
    return user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置UINavigationbar
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:235/255.0 green:133/255.0 blue:50/255.0 alpha:1];//背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.8];
   // [self insertBarGradient];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//返回按钮的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19]}];//设置标题的样式
    self.navigationController.navigationBar.translucent = YES;//不模糊
    
    self.bgView.backgroundColor =  [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.8];
   // self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
   // self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
   // self.bgView.layer.borderWidth = 1;
    
    self.userLabel.font = [UIFont boldSystemFontOfSize:17];
    
    self.view.backgroundColor = BG_COLOR;
    
    //颜色渐变
   // [self insertColorGradient];
    
    //暂时隐藏
  //  self.fontLabel.textColor = BG_COLOR;
    
    UIButton *update_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    update_btn.frame = (CGRect){0,0,40,20};
    update_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    update_btn.titleLabel.textColor = [UIColor whiteColor];
    [update_btn setTitle:@"更新" forState:UIControlStateNormal];
    [update_btn addTarget:self action:@selector(updateSystemAction) forControlEvents:UIControlEventTouchUpInside];
    update_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    update_btn.layer.borderWidth = 0.5;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:update_btn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)insertColorGradient
{
    UIColor *colorOne = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.8];
    
    UIColor *colorTwo = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:1.0];
    
    NSArray *colors = @[(id)colorOne.CGColor,(id)colorTwo.CGColor];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = @[stopOne,stopTwo];
    
    CAGradientLayer *headersLayers = [CAGradientLayer layer];
    headersLayers.colors = colors;
    headersLayers.locations = locations;
    headersLayers.frame = self.bgView.bounds;
    [self.bgView.layer insertSublayer:headersLayers atIndex:0];
}

- (void)insertBarGradient
{
    UIColor *colorOne = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.7];
    
    UIColor *colorTwo = [UIColor colorWithRed:234/255.0 green:86/255.0 blue:14/255.0 alpha:0.8];
    
    NSArray *colors = @[(id)colorOne.CGColor,(id)colorTwo.CGColor];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = @[stopOne,stopTwo];
    
    CAGradientLayer *headersLayers = [CAGradientLayer layer];
    headersLayers.colors = colors;
    headersLayers.locations = locations;
    headersLayers.frame = self.navigationController.navigationBar.bounds;
    [self.navigationController.navigationBar.layer insertSublayer:headersLayers atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - updateSystem
//版本更新
- (void)updateSystemAction
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    [RequestObject getVersionsWithCallback:^(NSDictionary *jsonDict) {
        [SVProgressHUD dismissWithSuccess:@"加载成功"];
        NSString *strVer = [jsonDict objectForKey:@"version"];
        if ([self compareWithAppVersion:strVer]) {
        NSString *str = [NSString stringWithFormat:@"当前有最新版本%@,是否立即更新",strVer];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;//表示更新
        [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } error:^{
        [SVProgressHUD dismissWithError:@"加载失败"];
    }];
}

#pragma mark - Private Method
//- (void)requestHttp
//{
////    [SVProgressHUD showWithStatus:@"加载中.."];
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        
////        if ([RequestObject fetchWithType:@"CheckVersion" withResults:@"ios"]) {
////            [self updateUI];
////        }else{
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [SVProgressHUD dismissWithError:@"加载失败"];
////            });
////        }
////    });
//    
//    //更新版本
//    [SVProgressHUD showWithStatus:@"加载中.."];
//    RequestObject *re = [[RequestObject alloc] init];
//    [re getVersionsWithCallback:nil error:nil];
//}

//- (void)updateUI
//{
//    [SVProgressHUD dismissWithSuccess:@"加载成功"];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSArray *list = [RequestObject requestData];
//        if (list.count != 0) {
//            NSString *ver =  [list[0] objectForKey:@"strThisVersion"];
//            _url = [list[0] objectForKey:@"strGetNewVersionURL"];
//            if ([self compareWithAppVersion:ver]) {
//                //更新
//                NSString *str = [NSString stringWithFormat:@"当前有最新版本%@,是否立即更新",ver];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//                alert.tag = 1001;//表示更新
//                [alert show];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求的网络数据为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    });
//}

//版本比较，有新版本返回YES，无新版本返回NO
- (BOOL)compareWithAppVersion:(NSString *)version
{
    if (![version isEqualToString:@""]) {
        //先获取当前软件版本号
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if (![version isEqualToString:currentVersion]) {
            //有新版本
            return YES;
        }else{
            //没有新版本
            return NO;
        }
    }else{
        //版本号为空，不更新
        return NO;
    }
}

- (IBAction)selectPeopleAction:(id)sender {
    //选择人员信息
    PeopleSelectController *people = [[PeopleSelectController alloc] init];
    [self.navigationController pushViewController:people animated:YES];
}

//点餐
- (IBAction)bookAction:(id)sender
{
    NSDictionary *user = [self getUserName];
    NSString *name = (NSString *)[user objectForKey:@"Sname"];
    NSString *Sid = (NSString *)[user objectForKey:@"Sid"];
    if ([name length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择订餐人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1002;
        [alert show];
        return;
    }
    //[self.navigationController performSegueWithIdentifier:@"bookPush" sender:nil];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantViewController *restaurant = [story instantiateViewControllerWithIdentifier:@"BookController"];
    restaurant.personId = Sid;//将人员编号传递进去
    [self.navigationController pushViewController:restaurant animated:YES];
}



//进入会议室预定
- (IBAction)bookMeetingRoomAction:(id)sender
{
    NSDictionary *user = [self getUserName];
    NSString *name = (NSString *)[user objectForKey:@"Sname"];
    if ([name length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择预定人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1002;
        [alert show];
        return;
    }
    [self performSegueWithIdentifier:@"meetingRoom" sender:nil];
}

//视频播放
- (IBAction)playVideoAction:(id)sender
{
    [self performSegueWithIdentifier:@"video" sender:nil];
}

//投票
- (IBAction)voteAction:(id)sender
{
    NSDictionary *user = [self getUserName];
    NSString *name = (NSString *)[user objectForKey:@"Sname"];
    if ([name length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择预定人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1002;
        [alert show];
        return;
    }
    [self performSegueWithIdentifier:@"vote" sender:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1){
            //更新
            NSString *str = [NSString stringWithFormat:@"http://fir.im/dcxx"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }else if(alertView.tag == 1002){
        if (buttonIndex == 0) {
            //直接进入组织架构选人
            [self performSelector:@selector(selectPeopleAction:) withObject:nil];
        }
    }
}
@end
