//
//  OrderDetailController.h
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailController : UIViewController

@property (nonatomic, copy) NSString *restaurantId;//餐厅编号

@property (nonatomic, assign) BOOL isCanBook;//是否能进行预定

@end
