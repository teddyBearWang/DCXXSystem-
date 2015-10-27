//
//  MeetingCell.m
//  DCXXSystem
//
//  Created by teddy on 15/8/13.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MeetingCell.h"

@implementation MeetingCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bookbtn.layer.cornerRadius = 8;
    self.bookbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.bookbtn.backgroundColor = [UIColor colorWithRed:37/255.0 green:155/255.0 blue:36/255.0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
