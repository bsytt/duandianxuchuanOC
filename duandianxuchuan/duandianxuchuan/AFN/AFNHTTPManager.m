//
//  AFNHTTPManager.m
//  duandianxuchuan
//
//  Created by 包曙源 on 2019/3/11.
//  Copyright © 2019年 bsy. All rights reserved.
//

#import "AFNHTTPManager.h"

@implementation AFNHTTPManager

+(AFHTTPSessionManager*)shareManager{
    
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.deda.cin"];
        configuration.HTTPMaximumConnectionsPerHost = 8;  //同时下载数量
        configuration.sessionSendsLaunchEvents = YES;
//        manager = [AFHTTPSessionManager manager];
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        
    });
    return manager;
}
@end
