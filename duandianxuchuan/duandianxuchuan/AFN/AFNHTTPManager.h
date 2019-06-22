//
//  AFNHTTPManager.h
//  duandianxuchuan
//
//  Created by 包曙源 on 2019/3/11.
//  Copyright © 2019年 bsy. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


@interface AFNHTTPManager : AFHTTPSessionManager

+(AFHTTPSessionManager*)shareManager;

@end

