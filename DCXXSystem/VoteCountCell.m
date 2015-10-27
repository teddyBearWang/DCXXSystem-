//
//  VoteCountCell.m
//  DCXXSystem
//
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "VoteCountCell.h"

@implementation VoteCountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)upgateCell:(NSDictionary *)dict
{
    self.layer.cornerRadius = 10.0;
    self.layer.shadowOffset = CGSizeMake(3, 3);//向右偏移3，向下偏移3
    self.layer.shadowOpacity = 0.8;//默认是0
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    self.contentText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentText.layer.borderWidth = 0.4;
    self.contentText.editable = NO;
    self.contentText.text = [dict objectForKey:@"Title"];
    self.approvalLabel.text = [NSString stringWithFormat:@"赞成:%@",[dict objectForKey:@"OkCount"]];
    self.angistLabel.text = [NSString stringWithFormat:@"反对:%@",[dict objectForKey:@"NoOkCount"]];
}
@end
