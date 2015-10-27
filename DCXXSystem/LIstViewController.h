//
//  LIstViewController.h
//  DCXXSystem
//  ***************详情或者列表*********
//  Created by teddy on 15/8/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义一个无返回值的block
typedef void(^SelectBlock)(NSString* selectedStr); //定义一个block,参数为"选择的string "

@interface LIstViewController : UIViewController

@property (nonatomic, strong) NSArray *sourceData;//数据源

@property (nonatomic, assign) int index;

//定义成属性
@property (nonatomic, strong) SelectBlock selectBlock;

//重新定义setter方法
//- (void)setSelectBlock:(SelectBlock)selectBlock;

@end
