//
//  LLDecodeThread.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLDecodeThread.h"
#import "LLDecoder.h"
#import "LLQueue.h"

@interface LLDecodeThread ()
@property (nonatomic, strong) LLDecoder *decoder;
@property (nonatomic, strong) LLQueue *packetQueue;
@end

@implementation LLDecodeThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.decoder = [[LLDecoder alloc] init];
        self.packetQueue = [[LLQueue alloc] init];
    }
    return self;
}


- (int)initialDecoderWithStream:(LLAVStream *)stream {
    return [self.decoder initialDecoder:stream];
}

- (int)putPacket:(LLAVPacket *)packet {
    return [self.packetQueue push:packet];
}

- (int)getPacketSize {
    return self.packetQueue.size;
}

- (void)run {
    // 解码
    while (!self.stopFlag) {
        [NSThread sleepForTimeInterval:0.1];

        if (self.packetQueue.size == 0) {
            break;
        }
        LLAVPacket *packet = [self.packetQueue pop];
        if (!packet) {
            // 没有取到
            continue;
        }
        
        int ret = [self.decoder sendPacket:packet];
        if (!ret) {
            packet = nil;
        }
        
        while (1) {
            LLAVFrame *frame = [[LLAVFrame alloc] init];
            ret = [self.decoder receiveFrame:frame];
            if (ret) {
                break;
            }
            
            if (self.streamType == 0) {
                [self.controlThread pushVideoFrame:frame];
            } else if (self.streamType == 1) {
                [self.controlThread pushAudioFrame:frame];
            }
            
        }
        
//        NSLog(@"decoder success!!");
    }
}


@end
