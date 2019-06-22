//
//  AFNTool.h
//  duandianxuchuan
//
//  Created by 包曙源 on 2019/3/11.
//  Copyright © 2019年 bsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFNTool : NSObject

+ (AFNTool *)shareAFNTool;
- (void)downMovie:(NSString *)urlStr name:(NSInteger)name back:(void (^)(CGFloat num,NSURLSessionDownloadTask *task)) backBlock suc:(void (^)(bool d,NSString *path)) suc;
- (NSURLSessionDownloadTask *)getSaveTmpFileback:(NSInteger)name backBlock:(void (^)(CGFloat num)) backBlock suc:(void (^)(bool d,NSString *path)) suc;

- (void)stop:(NSURLSessionDownloadTask *)task ;
- (void)resume:(NSURLSessionDownloadTask *)task;
- (void)cancelDownLoad:(NSURLSessionDownloadTask *)task name:(NSInteger)name;
@end

