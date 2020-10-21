//
//  LLReader.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLReader.h"

@interface LLReader ()
@property (nonatomic) AVFormatContext *formatCtx;

@end

@implementation LLReader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (int)getStream:(LLAVStream *)stream streamId:(NSInteger)streamId {
    AVStream *ffm_Stream = _formatCtx->streams[streamId];
    stream.streamIndex = ffm_Stream->index;
    stream.timebaseDen = ffm_Stream->time_base.den;
    stream.timebaseNum = ffm_Stream->time_base.num;
    int ret = avcodec_parameters_copy(stream.codecpar, ffm_Stream->codecpar);
    return ret;
}

- (int)getVideoStreamIndex {
    return av_find_best_stream(_formatCtx, AVMEDIA_TYPE_VIDEO, -1, -1, NULL, 0);
}

- (int)getAudioStreamIndex {
    return av_find_best_stream(_formatCtx, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
}

- (NSInteger)streamCount {
    return _formatCtx->nb_streams;
}

- (int)open:(NSString *)url {
    if (_formatCtx == nil) {
        return -1;
    }
    int ret = avformat_open_input(&_formatCtx, url.UTF8String, NULL, NULL);
    if (!ret) {
        avformat_find_stream_info(_formatCtx, NULL);
    }
    return ret;
}

- (int)close {
    avformat_close_input(&_formatCtx);
    return 0;
}

- (int)read:(LLAVPacket *)packet {
    if (_formatCtx == nil) {
        return -1;
    }
    
    int ret = av_read_frame(_formatCtx, packet.pkt);
    
    return ret;
}

- (void)setup {
    _formatCtx = avformat_alloc_context();
}

- (void)dealloc {
    if (_formatCtx != nil) {
        avformat_free_context(_formatCtx);
        _formatCtx = nil;
    }
}
@end
