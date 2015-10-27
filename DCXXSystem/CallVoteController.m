//
//  CallVoteController.m
//  DCXXSystem
//  **********发起投票************
//  Created by teddy on 15/9/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CallVoteController.h"
#import "RequestObject.h"
#import "SVProgressHUD.h"

@interface CallVoteController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *voteContent;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;

//确认发起投票
- (IBAction)confirmCallVoteAction:(id)sender;

//取消键盘
- (IBAction)tapBackgroundAction:(id)sender;
@end

@implementation CallVoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //使UITextView中的内容顶着最上面显示
    [self.voteContent setContentSize:CGSizeZero];
    //设置内容向上偏移-50像素
    [self.voteContent setContentInset:UIEdgeInsetsMake(-50, 0, 0, 0)];
    self.voteContent.layer.borderWidth = 1.0f;
    self.voteContent.layer.borderColor = [UIColor blackColor].CGColor;
    self.voteContent.delegate = self;
    
    self.view.backgroundColor = BG_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确认发起投票
- (IBAction)confirmCallVoteAction:(id)sender
{
    if (self.voteContent.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对于投票的内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self callRequestAction];
}

- (void)callRequestAction
{
    [SVProgressHUD showWithStatus:@"发起中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RequestObject fetchWithType:@"IntStartVote" withResults:self.voteContent.text]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"发起投票失败"];
            });
        }
    });
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *list = [RequestObject requestData];
        if (list.count != 0) {
            [SVProgressHUD dismissWithSuccess:@"发起投票成功"];
           // [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD dismissWithError:@"发起投票失败"];
        }
    });
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

//取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    [self.voteContent resignFirstResponder];
}

@end
