//
//  LLDecoder.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLDecoder.h"

@interface LLDecoder ()
@property (nonatomic) AVCodecContext *codexCtx;
@property (nonatomic, assign) NSTimeInterval timebaseNum;
@property (nonatomic, assign) NSTimeInterval timebaseDen;
@end

@implementation LLDecoder

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (int)initialDecoder:(LLAVStream *)stream {
    self.timebaseNum = stream.timebaseNum;
    self.timebaseDen = stream.timebaseDen;
    
    avcodec_parameters_to_context(_codexCtx, stream.codecpar);
    AVCodec *codec = avcodec_find_decoder(_codexCtx->codec_id);
    int ret = avcodec_open2(_codexCtx, codec, NULL);
    if (ret) {
        NSLog(@"打开解码器失败");
        return -1;
    }
    self.streamIndex = stream.streamIndex;
    return ret;
}

- (int)sendPacket:(LLAVPacket *)packet {
    if (packet == NULL) {
        int ret = avcodec_send_packet(_codexCtx, NULL);
        return ret;
    } else {
        
        int ret = avcodec_send_packet(_codexCtx, packet.pkt);
        return ret;
    }
}

- (int)receiveFrame:(LLAVFrame *)frame {
    int ret = avcodec_receive_frame(_codexCtx, frame.frame);
    if (!ret) {
        frame.ptsSec = (frame.frame->pts * self.timebaseNum / self.timebaseDen);
    }
    return ret;
}

- (void)close {
    avcodec_close(_codexCtx);
}

- (void)setup {
    _codexCtx = avcodec_alloc_context3(NULL);
}

- (void)dealloc {
    if (_codexCtx != nil) {
        avcodec_free_context(&_codexCtx);
        _codexCtx = nil;
    }
}
@end
