//
//  VideoPlayController.m
//  DCXXSystem
//
//  Created by teddy on 15/9/6.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VideoPlayController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

@interface VideoPlayController ()<UIWebViewDelegate>
{
    UIWebView *webVIew;
}

@end

@implementation VideoPlayController



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [SVProgressHUD dismiss                                                                                                                                                       ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频播放";
    
    self.view.backgroundColor = BG_COLOR;
    
    webVIew = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    //http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
    //http://115.236.2.245:38019/upload/video/rec003.mp4
    NSURL *url = [NSURL URLWithString:@"http://115.236.2.245:38019/upload/video/rec003.mp4"];
    [webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    [webVIew setDelegate:self];
    [self.view addSubview:webVIew];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil]; //进入全屏
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil]; //退出全屏
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeKeyAction) name:UIWindowDidBecomeKeyNotification object:nil]; //变成keywindow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelKeyAction) name:UIWindowDidResignKeyNotification object:nil]; //变成非keywindow
    
    
    
}

- (void)becomeKeyAction
{
    NSLog(@"变成keyWindow");
}

- (void)cancelKeyAction
{
    NSLog(@"变成非keyWindow");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

#pragma mark -
//进入全屏
- (void)begainFullScreen
{
    NSLog(@"Window显示");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isFull = YES;
}

//取消全屏
- (void)endFullScreen
{
    NSLog(@"window隐藏");
    [SVProgressHUD dismiss];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isFull = NO;
    
    //强制屏幕竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
@end
