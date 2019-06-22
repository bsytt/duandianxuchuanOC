//
//  DownLoadView.m
//  duandianxuchuan
//
//  Created by 包曙源 on 2019/3/13.
//  Copyright © 2019年 bsy. All rights reserved.
//

#import "DownLoadView.h" 

@implementation DownLoadView
- (IBAction)resumeDownOneSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(RESUMEDOWNONE);
    }
}

- (IBAction)cancelOneSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(CANCELONE);
    }
}

- (IBAction)stopOneSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(STOPONE);
    }
}
- (IBAction)resumeOneSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(RUSUMEONE);
    }
}

- (IBAction)startSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(START);
    }
}
- (IBAction)startOneSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(STARTONE);
    }
}
- (IBAction)stopSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(STOP);
    }
}
- (IBAction)rusumeSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(RUSUME);
    }
}
- (IBAction)cancelSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(CANCEL);
    }
}
- (IBAction)rusumeDownSelect:(id)sender {
    if (self.selectBtnBLock) {
        self.selectBtnBLock(RUSUMEDOWNLOAD);
    }
}

@end
