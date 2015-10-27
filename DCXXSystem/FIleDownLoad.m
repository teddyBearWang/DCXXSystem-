//
//  FIleDownLoad.m
//  DCXXSystem
//
//  Created by teddy on 15/8/11.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FIleDownLoad.h"
#import <AFNetworking.h>

static FIleDownLoad *downloadFile = nil;

@implementation FIleDownLoad

//设置成单例模式
+ (FIleDownLoad *)shareTheme
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadFile = [[FIleDownLoad alloc] init];
    });
    return downloadFile;
}

- (void)downloadFileWithUrl:(NSString *)fileUrl
{
    //aFileUrl = http://115.236.169.28/xjxly/FileDoc/12345.pdf
    NSString *filePath = [self cacheFile:fileUrl];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        //文件存在，直接发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FILEDOWNLOADCOMPLETE object:filePath];
    }else{
        //不存在，开始下载
        [self loadFileFromUrl:fileUrl];
    }
}

//先根据文件的下载地址，创建文件的在本地的保存路径
- (NSString *)cacheFile:(NSString *)filename
{
    ////aFileUrl = http://115.236.169.28/xjxly/FileDoc/12345.pdf
    
    //获取根目录,document路径
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //PDF文件夹的路劲
    cacheFolder = [cacheFolder stringByAppendingPathComponent:@"PDF"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheFolder]) {
        //表示文件夹不存在，需要创建这个文件夹
        NSError *error = nil;
        
        [fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return nil;
        }
    }
    
    //将传入的下载地址根据"/"分割成数组
    NSArray *paths = [filename componentsSeparatedByString:@"/"];
    if (paths.count == 0) {
        return nil;
    }
    
    NSString *filepath = [NSString stringWithFormat:@"%@/%@",cacheFolder,[paths lastObject]];
    return filepath;
    
}

#pragma mark - 下载文件，下载结束之后，发出通知
- (void)loadFileFromUrl:(NSString *)fileUrl
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation = nil;
    
    NSString *url = [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    @try {
        operation = [manager GET:url parameters:nil success:nil failure:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"异常的原因是:%@",[exception description]);
    }
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        //得到PDF文件的缓存路径
        NSString *filePath = [self cacheFile:fileUrl];
        [operation.responseData writeToFile:filePath atomically:YES];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FILEDOWNLOADCOMPLETE object:filePath];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:FILEDOWNLOADFAIL object:[self cacheFile:fileUrl]];
    }
   
}
@end
