//
//  AFNTool.m
//  duandianxuchuan
//
//  Created by 包曙源 on 2019/3/11.
//  Copyright © 2019年 bsy. All rights reserved.
//

#import "AFNTool.h"
#import "AFNHTTPManager.h"

@interface AFNTool()
{
    BOOL goon;
}
@property (nonatomic , strong) NSURLSessionDownloadTask *task;
@end

@implementation AFNTool
+ (AFNTool *)shareAFNTool {
    static AFNTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFNTool alloc]init];
    });
    return manager;
}
- (void)downMovie:(NSString *)urlStr name:(NSInteger)name back:(void (^)(CGFloat num,NSURLSessionDownloadTask *task)) backBlock suc:(void (^)(bool d,NSString *path)) suc{
    AFHTTPSessionManager *manager = [AFNHTTPManager shareManager];
    manager.requestSerializer.timeoutInterval = 5.0;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"23134543223" forHTTPHeaderField:@"session_ID"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak __typeof(self)weakSelf = self;
    self.task =  [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat f = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        backBlock(f,weakSelf.task);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error == nil){
            NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:imgFilePath]) {
                BOOL b = [fileManager removeItemAtPath:[self getTmpFileUrl:name] error:nil];
                suc(b,imgFilePath);
            }
        }else {
            NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
            NSString *path = [self getTmpFileUrl:name];
            [resumeData writeToFile:path atomically:NO];
        }
    }];
    goon = YES;
    [self.task resume];
    NSLog(@"%@",manager.downloadTasks);


}
- (void)stop:(NSURLSessionDownloadTask *)task {
       [task suspend];
}
- (void)resume:(NSURLSessionDownloadTask *)task {
       [task resume];
}
- (void)cancelDownLoad:(NSURLSessionDownloadTask *)task name:(NSInteger)name{
    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        NSString *path = [self getTmpFileUrl:name];
        [resumeData writeToFile:path atomically:NO];
    }];
}

- (NSURLSessionDownloadTask *)getSaveTmpFileback:(NSInteger)name backBlock:(void (^)(CGFloat num)) backBlock suc:(void (^)(bool d,NSString *path)) suc{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [self getTmpFileUrl:name];
    __block NSData *filedata = [fm contentsAtPath:path];
    __weak __typeof(self)weakSelf = self;

    AFHTTPSessionManager *manager = [AFNHTTPManager shareManager];
    manager.requestSerializer.timeoutInterval = 30.0;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"23134543223" forHTTPHeaderField:@"session_ID"];
    if (filedata == nil) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [manager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
                filedata = error.userInfo[NSURLSessionDownloadTaskResumeData];
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
            self.task = [manager downloadTaskWithResumeData:filedata progress:^(NSProgress * _Nonnull downloadProgress) {
                CGFloat f = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                backBlock(f);
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
                return [NSURL fileURLWithPath:path];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                if (error == nil){
                    NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:imgFilePath]) {
                        BOOL b = [fileManager removeItemAtPath:[self getTmpFileUrl:name] error:nil];
                        suc(b,imgFilePath);
                    }
                }
            }];
            [self.task resume];
        return self.task;
}

- (NSString *)getTmpFileUrl:(NSInteger)name{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str = [NSString stringWithFormat:@"%ld.tmp",name];
    NSString *finalPath = [docPath stringByAppendingPathComponent:str];
    [fileManager createDirectoryAtPath:[finalPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];//stringByDeletingLastPathComponent是关键
     return finalPath;
}
@end
