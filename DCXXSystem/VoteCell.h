//
//  VoteCell.h
//  DCXXSystem
//
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteCell : UITableViewCell
//时间标签
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//内容
@property (weak, nonatomic) IBOutlet UITextView *contentVIew;
//赞同按钮
@property (weak, nonatomic) IBOutlet UIButton *approvalBtn;
//反对按钮
@property (weak, nonatomic) IBOutlet UIButton *aginstBtn;
//状态标签
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
//关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

/*
 * dict:数据源
 *permission:是否有删除权限
 */

- (void)setContentName:(NSDictionary *)dict withPermission:(BOOL)permission;

@end
