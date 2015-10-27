//
//  FIleDownLoad.h
//  DCXXSystem
//  **********文件下载类***************
//  Created by teddy on 15/8/11.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILEDOWNLOADCOMPLETE @"fileDownloadComplete"

#define FILEDOWNLOADFAIL @"fileDownloadFail"

@interface FIleDownLoad : NSObject

//设置成单例模式
+ (FIleDownLoad *)shareTheme;

- (void)downloadFileWithUrl:(NSString *)fileUrl;

@end
