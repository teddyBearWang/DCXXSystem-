//
//  RequestObject.m
//  DCXXSystem
//  **********网络请求类*************
//  Created by teddy on 15/8/11.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RequestObject.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *_operation = nil;
@implementation RequestObject

+ (BOOL)fetchWithType:(NSString *)requestType withResults:(NSString *)result
{
    BOOL ret = NO;
    //http://115.236.2.245:38019/datadc.ashx?t=GetDept&results=0$&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parmater = @{@"t":requestType,
                               @"results":result,
                               @"returntype":@"json"};
    _operation = [manager POST:URL parameters:parmater success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        ret = YES;
        datas = (NSArray *)[NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
}

static NSArray *datas = nil;
+ (NSArray *)requestData
{
    return datas;
}


+ (void)cancelRequest
{
    if (_operation != nil) {
        [_operation cancel];
    }
}

//获取版本号
+ (void)getVersionsWithCallback:(void(^)(NSDictionary *jsonDict))callback error:(void(^)())errorback
{
    NSString *strUrl = @"http://api.fir.im/apps/latest/562dbcf7f2fc42499f00000c";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        callback(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorback(error);
    }];
}
@end
