//
//  HistoryCell.h
//  DCXXSystem
//
//  Created by teddy on 15/8/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *meetingRoomName; //会议室名称
@property (weak, nonatomic) IBOutlet UILabel *bookTimeLabel; //预定时间
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel; //部门名称
@property (weak, nonatomic) IBOutlet UILabel *machineLabel;//是否需要投影
@end
