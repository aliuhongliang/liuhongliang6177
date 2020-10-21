//
//  LLReaderThread.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLReaderThread.h"
#import "LLReader.h"
#import "LLDecodeThread.h"

@implementation LLReaderThread

- (void)run {
    
    LLReader *reader = [[LLReader alloc] init];
    int ret = [reader open:self.path];
    if (ret) {
        NSLog(@"打开文件失败");
        return;
    }
    
    int videoIndex = reader.getVideoStreamIndex;
    int audioIndex = reader.getAudioStreamIndex;
    
    LLDecodeThread *videoThread = [[LLDecodeThread alloc] init];
    videoThread.controlThread = self.controlThread;
    videoThread.streamType = 0;
    LLDecodeThread *audioThread = [[LLDecodeThread alloc] init];
    audioThread.controlThread = self.controlThread;
    audioThread.streamType = 1;
    
    LLAVStream *videoStream = [[LLAVStream alloc] init];
    [reader getStream:videoStream streamId:videoIndex];
    [videoThread initialDecoderWithStream:videoStream];
    
    LLAVStream *audioStream = [[LLAVStream alloc] init];
    [reader getStream:audioStream streamId:audioIndex];
    [audioThread initialDecoderWithStream:audioStream];
    
    [videoThread start];
    [audioThread start];
    
    
    
    while (!self.stopFlag) {
        
        if ([videoThread getPacketSize] > 5 && [audioThread getPacketSize] > 5) {
            continue;
        }
        
        LLAVPacket *packet = [LLAVPacket new];
        ret = [reader read:packet];
        if (ret) {
            break;
        }
        
        if (packet.streamIndex == videoIndex) {
            
            [videoThread putPacket:packet];
            
        } else if (packet.streamIndex == audioIndex) {
            [audioThread putPacket:packet];
        }
        
    }
    
    NSLog(@"reader finish or stop");
    
    [videoThread stop];
    [audioThread stop];
    [reader close];
}

- (void)dealloc {
    NSLog(@"LLReaderThread");
}
@end
