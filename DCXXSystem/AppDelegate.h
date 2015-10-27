//
//  AppDelegate.h
//  DCXXSystem
//
//  Created by teddy on 15/7/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL _isFull;//是否全屏
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) BOOL isFull;


@end

