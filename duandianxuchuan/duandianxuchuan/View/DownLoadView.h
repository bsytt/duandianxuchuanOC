//
//  DownLoadView.h
//  duandianxuchuan
//
//  Created by 包曙源 on 2019/3/13.
//  Copyright © 2019年 bsy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    START = 0,
    STARTONE,
    STOP,
    RUSUME,
    CANCEL,
    RUSUMEDOWNLOAD,
    STOPONE,
    RUSUMEONE,
    CANCELONE,
    RESUMEDOWNONE,
}SelectType;

typedef void(^SelectBtnBLock)(SelectType type);

@interface DownLoadView : UIView

@property (nonatomic , copy) SelectBtnBLock selectBtnBLock;

@property (weak, nonatomic) IBOutlet UILabel *proLb;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *proLb1;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView1;
@property (weak, nonatomic) IBOutlet UIButton *startBtn1;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *rusumeDownBtn;

@end

