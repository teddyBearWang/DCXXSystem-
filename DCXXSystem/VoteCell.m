//
//  VoteCell.m
//  DCXXSystem
//
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VoteCell.h"

@implementation VoteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentName:(NSDictionary *)dict withPermission:(BOOL)permission
{
    self.contentVIew.editable = NO;
    self.layer.cornerRadius = 10.0;
    self.layer.shadowOffset = CGSizeMake(3, 3);//向右偏移3，向下偏移3
    self.layer.shadowOpacity = 0.8;//默认是0
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [self.contentVIew setContentSize:CGSizeZero];
    self.backgroundColor = [UIColor whiteColor];
    self.approvalBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.approvalBtn.layer.borderWidth = 0.3;
    self.approvalBtn.layer.cornerRadius = 5.0;
    
    self.aginstBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.aginstBtn.layer.borderWidth = 0.3;
    self.aginstBtn.layer.cornerRadius = 5.0;
    if (permission) {
        //有权限
        self.closeBtn.hidden = NO;//显示
        self.closeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.closeBtn.layer.borderWidth = 0.3;
        self.closeBtn.layer.cornerRadius = 5.0;
        
        [self.approvalBtn setTitle:[NSString stringWithFormat:@"赞成(%@)",[dict objectForKey:@"OkCount"]] forState:UIControlStateNormal];
         [self.aginstBtn setTitle:[NSString stringWithFormat:@"反对(%@)",[dict objectForKey:@"NoOkCount"]] forState:UIControlStateNormal];
    }

    self.dateLabel.text = [dict objectForKey:@"Sdatetime"];
    self.contentVIew.text = [dict objectForKey:@"Title"];
    
    if ([[dict objectForKey:@"VoteRes"] isEqualToString:@"0"]) {
        self.stateLabel.text = @"未投票";
    }else{
        if([[dict objectForKey:@"VoteRes"] isEqualToString:@"1"])
        {
            self.stateLabel.text = @"已投票(赞同)";
        }else{
             self.stateLabel.text = @"已投票(反对)";
        }
        self.approvalBtn.userInteractionEnabled = NO;
        [self.approvalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.aginstBtn.userInteractionEnabled = NO;
        [self.aginstBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

@end
