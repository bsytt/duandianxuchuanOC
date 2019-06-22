//
//  ViewController.m
//  duandianxuchuan
//
//  Created by 包曙源 on 2019/3/11.
//  Copyright © 2019年 bsy. All rights reserved.
//

#import "ViewController.h"
#import "AFN/AFNTool.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DownLoadView.h"

@interface ViewController ()


@property (nonatomic , strong) AFNTool *t;

@property (nonatomic , strong) DownLoadView *downLoadView;

@property (nonatomic , strong) NSURLSessionDownloadTask *task;
@property (nonatomic , strong) NSMutableDictionary *tasks;
@end

@implementation ViewController
- (NSMutableDictionary *)tasks {
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}
- (DownLoadView *)downLoadView {
    if (!_downLoadView) {
        _downLoadView = [[[NSBundle mainBundle] loadNibNamed:@"DownLoadView" owner:self options:nil] lastObject];
    }
    return _downLoadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.downLoadView];
    
    __weak __typeof(self)weakSelf = self;
    self.downLoadView.selectBtnBLock = ^(SelectType type) {
        switch (type) {
            case START:
                [weakSelf dowoLoad:weakSelf.downLoadView.progressView proLb:weakSelf.downLoadView.proLb urlStr:@"http://220.249.115.46:18080/wav/Lovey_Dovey.mp4" name:0];
                break;
            case STARTONE:
                [weakSelf dowoLoad:weakSelf.downLoadView.progressView1 proLb:weakSelf.downLoadView.proLb1 urlStr:@"http://220.249.115.46:18080/wav/day_by_day.mp4" name:1];
                break;
            case STOP:{
                NSString *url = @"http://220.249.115.46:18080/wav/Lovey_Dovey.mp4";
                NSURLSessionDownloadTask *task = [weakSelf.tasks objectForKey:url];
                [weakSelf.t stop:task];
            }
                break;
            case RUSUME:{
                NSString *url = @"http://220.249.115.46:18080/wav/Lovey_Dovey.mp4";
                NSURLSessionDownloadTask *task = [weakSelf.tasks objectForKey:url];
                [weakSelf.t resume:task];
            }
                break;
            case CANCEL:{
                NSString *url = @"http://220.249.115.46:18080/wav/Lovey_Dovey.mp4";
                NSURLSessionDownloadTask *task = [weakSelf.tasks objectForKey:url];
                [weakSelf.t cancelDownLoad:task name:0];
            }
                break;
            case RUSUMEDOWNLOAD:
                [weakSelf duanS:weakSelf.downLoadView.progressView proLb:weakSelf.downLoadView.proLb key:@"http://220.249.115.46:18080/wav/Lovey_Dovey.mp4" name:0];
                break;
            case STOPONE:{
                NSString *url = @"http://220.249.115.46:18080/wav/day_by_day.mp4";
                NSURLSessionDownloadTask *task = [weakSelf.tasks objectForKey:url];
                [weakSelf.t stop:task];
            }
                break;
            case RUSUMEONE:{
                NSString *url = @"http://220.249.115.46:18080/wav/day_by_day.mp4";
                NSURLSessionDownloadTask *task = [weakSelf.tasks objectForKey:url];
                [weakSelf.t resume:task];
            }
                break;
            case CANCELONE:{
                NSString *url = @"http://220.249.115.46:18080/wav/day_by_day.mp4";
                NSURLSessionDownloadTask *task = [weakSelf.tasks objectForKey:url];
                [weakSelf.t cancelDownLoad:task name:1];
            }
                break;
            case RESUMEDOWNONE:
                [weakSelf duanS:weakSelf.downLoadView.progressView1 proLb:weakSelf.downLoadView.proLb1 key:@"http://220.249.115.46:18080/wav/day_by_day.mp4" name:1];
                break;
            default:
                break;
        }
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadEnd) name:@"downloadEnd" object:nil];
}
- (void)downloadEnd {
    self.downLoadView.proLb.text = @"100.00%";
    self.downLoadView.progressView.progress = 1;
}

- (void)dowoLoad:(UIProgressView *)pro proLb:(UILabel *)proLb urlStr:(NSString *)url name:(NSInteger)name{
    __weak __typeof(self)weakSelf = self;
    _t = [AFNTool shareAFNTool];
    [_t downMovie:url name:name back:^(CGFloat num, NSURLSessionDownloadTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            proLb.text = [NSString stringWithFormat:@"%.2f%%",num*100];
            pro.progress = num;
            if (![self.tasks.allKeys containsObject:url]) {
                [self.tasks setObject:task forKey:url];
            }
        });
    } suc:^(bool d, NSString *path) {
        [weakSelf play:path];
    }];
}

- (void)duanS :(UIProgressView *)pro proLb:(UILabel *)proLb key:(NSString *)key name:(NSInteger)name{
    __weak __typeof(self)weakSelf = self;
    if (_t == nil) {
        _t = [AFNTool shareAFNTool];
    }
    NSURLSessionDownloadTask *task = [_t getSaveTmpFileback:name backBlock:^(CGFloat num) {
        dispatch_async(dispatch_get_main_queue(), ^{
            proLb.text = [NSString stringWithFormat:@"%.2f%%",num*100];
            pro.progress = num;
        });
    } suc:^(bool d, NSString *path) {
        [weakSelf play:path];
    }];
    if (![self.tasks.allValues containsObject:task]) {
        [self.tasks setObject:task forKey:key];
    }
}
- (void)play:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
    AVPlayerViewController *playrC = [[AVPlayerViewController alloc]init];
    playrC.player = player;
    [self presentViewController:playrC animated:YES completion:^{
        [playrC.player play];
    }];
}
@end
