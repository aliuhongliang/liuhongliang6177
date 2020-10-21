//
//  LLPlayerControlThread.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/21.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLPlayerControlThread.h"
#import "LLReaderThread.h"
#import "LLQueue.h"
#import "LLAVFrame.h"

@interface LLPlayerControlThread ()

@property (nonatomic, strong) LLQueue *videoFrameQueue;
@property (nonatomic, strong) LLQueue *audioFrameQueue;

@end

@implementation LLPlayerControlThread
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoFrameQueue = [LLQueue new];
        self.audioFrameQueue = [LLQueue new];
    }
    return self;
}

- (int)getVideoQueueSize {
    return self.videoFrameQueue.size;
}

- (int)getAudioQueueSize {
    return self.audioFrameQueue.size;
}

- (int)pushVideoFrame:(LLAVFrame *)frame {
    return [self.videoFrameQueue push:frame];
}

- (int)pushAudioFrame:(LLAVFrame *)frame {
    return [self.audioFrameQueue push:frame];
}

- (void)run {
//    NSString *str = [[NSBundle mainBundle] pathForResource:@"liu_ffmpeg" ofType:@"mov"];
    NSString *str = [[NSBundle mainBundle] pathForResource:@"liu_ffmpeg1" ofType:@"mp4"];
    LLReaderThread *readerThread = [[LLReaderThread alloc] initWithPath:str];
    readerThread.controlThread = self;
    [readerThread start];
    
    // 获取线程启动的时间 systime
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval startTime = [date timeIntervalSince1970];
    
    LLAVFrame *videoFrame = nil;
    LLAVFrame *audioFrame = nil;
    
    while (!self.stopFlag) {
//        NSLog(@"________________________________");
        // 获取当前的时间 curtime
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval curTime = [date timeIntervalSince1970];
//        NSLog(@"当前-时间戳：%.1f",curTime);
        
        // 获取两者的差值 d_time
        NSTimeInterval dTime = curTime - startTime;
//        NSLog(@"差值-时间戳：%.1f",dTime);
        
        // 从视频缓存队列中获取一帧视频的 frame_pts
        if (videoFrame == nil) {
            
            videoFrame = [self.videoFrameQueue pop];
        }
        if (videoFrame) {
            // 如果 frame_pts <= d_time 需要立即播放
            if ([videoFrame getPts] <= dTime) {
                NSLog(@"播放视频%f",[videoFrame getPts]);
                videoFrame = nil;
            } else {
                // 否则自旋
            }
        }
        
        
        // 从音频缓存队列中获取一帧音频的 frame_pts
        if (audioFrame == nil) {
            
            audioFrame = [self.audioFrameQueue pop];
        }
        if (audioFrame) {
            // 如果 frame_pts <= d_time 需要立即播放
            if ([audioFrame getPts] <= dTime) {
//                NSLog(@"播放音频%f",[videoFrame getPts]);
                audioFrame = nil;
            } else {
                // 否则自旋
            }
        }
    }
    
    [readerThread stop];
}
@end
