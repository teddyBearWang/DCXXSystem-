//
//  RequestObject.h
//  DCXXSystem
//
//  Created by teddy on 15/8/11.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestObject : NSObject

/*
 *requestType:请求的网络类型
 *result:上传的参数
 */
+ (BOOL)fetchWithType:(NSString *)requestType withResults:(NSString *)result;

//获取版本号
+ (void)getVersionsWithCallback:(void(^)(NSDictionary *jsonDict))callback error:(void(^)())errorback;

/*
 *接受网络数据
 */
+ (NSArray *)requestData;

/*
 *取消网络请求
 */
+ (void)cancelRequest;
@end
