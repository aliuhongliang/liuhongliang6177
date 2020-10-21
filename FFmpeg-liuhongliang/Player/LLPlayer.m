//
//  LLPlayer.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLPlayer.h"
#import "LLReader.h"
#import "LLDecoder.h"
#import "LLQueue.h"
#import "LLReaderThread.h"
#import "LLDecodeThread.h"
#import "LLPlayerControlThread.h"

@interface LLPlayer ()
@property (nonatomic, strong) LLReader *reader;
@property (nonatomic, strong) LLReaderThread *readerThread;
@property (nonatomic, strong) LLDecodeThread *decodeThread;
@property (nonatomic, strong) LLPlayerControlThread *controlThread;

@property (nonatomic, strong) NSMutableArray *decoderList;
@property (nonatomic, strong) LLQueue *queue;
@end

@implementation LLPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.reader = [[LLReader alloc] init];
    _decoderList = [NSMutableArray array];
    _queue = [[LLQueue alloc] init];
}

- (int)play {
    return 0;
}

- (int)pause {
    return 0;
}

- (int)stop {
    if (self.readerThread) {
        [self.readerThread stop];
        self.readerThread = nil;
        return 0;
    }
    
    return -1;
}

- (int)open:(NSString *)url {
    if (self.controlThread == nil) {
        self.controlThread = [[LLPlayerControlThread alloc] init];
        [self.controlThread start];
        return 0;
    }
    return -1;
    
//    int ret = [_reader open:url];
//    if (ret) {
//        NSLog(@"打开文件失败");
//        return -1;
//    }
//
//    int videoIndex = _reader.getVideoStreamIndex;
//    int audioIndex = _reader.getAudioStreamIndex;
//
//    NSInteger count = _reader.streamCount;
//
//    for (NSInteger i = 0; i < count; i++) {
//        LLAVStream *stream = [[LLAVStream alloc] init];
//         [_reader getStream:stream streamId:i];
//
//        NSLog(@"streamIndex:%ld",stream.streamIndex);
//
//        LLDecoder *decoder = [[LLDecoder alloc] init];
//        [decoder initialDecoder:stream];
//
//        [_decoderList addObject:decoder];
//    }
//
//    while (1) {
//        LLAVPacket *packet = [LLAVPacket new];
//
//        [_queue push:packet];
//
//        ret = [_reader read:packet];
//        if (ret) {
//            break;
//        }
//
//        // 获取解码器
//        NSInteger index = packet.streamIndex;
//        LLDecoder *decoder;
//        for (LLDecoder *temp in self.decoderList) {
//            if (temp.streamIndex == index) {
//                decoder = temp;
//                break;
//            }
//        }
//
//        int ret = [decoder sendPacket:packet];
//        if (ret) {
//            continue;
//        }
//
//        while (1) {
//            LLAVFrame *frame = [[LLAVFrame alloc] init];
//            ret = [decoder receiveFrame:frame];
//            if (ret) {
//                break;
//            }
//
//            if (index == videoIndex) {
////                [frame printVideoFrame];
//            } else if (index == audioIndex) {
////                [frame printAudioFrame];
//            }
//        }
//
////        NSLog(@"读取成功");
//
//    }
//
//    // 从decoder中获取packet
//    for (LLDecoder *decoder in self.decoderList) {
//        [decoder sendPacket:NULL];
//
//        while (1) {
//            LLAVFrame *frame = [[LLAVFrame alloc] init];
//            ret = [decoder receiveFrame:frame];
//            if (ret) {
//                break;
//            }
//        }
//    }
//
//
//    [_queue flush];
////    while (_queue.size > 0) {
////        LLAVPacket *packet;
////        [_queue pop:packet];
////        packet = nil;
////        NSLog(@"%d",_queue.size);
////    }
//
//    [_reader close];
//
//    for (LLDecoder *decoder in self.decoderList) {
//        [decoder close];
//    }
//
//    [self.decoderList removeAllObjects];
//    return 0;
}
@end
