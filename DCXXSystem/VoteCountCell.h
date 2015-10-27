//
//  VoteCountCell.h
//  DCXXSystem
//
//  Created by teddy on 15/10/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UILabel *approvalLabel;
@property (weak, nonatomic) IBOutlet UILabel *angistLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

- (void)upgateCell:(NSDictionary *)dict;
@end
