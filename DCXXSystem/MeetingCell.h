//
//  MeetingCell.h
//  DCXXSystem
//
//  Created by teddy on 15/8/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel; //时间label
@property (weak, nonatomic) IBOutlet UIButton *bookbtn; //预定按钮

@end
