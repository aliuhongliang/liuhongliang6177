//
//  LLAVFrame.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLAVFrame.h"
#import "pixfmt.h"
#import "pixdesc.h"

@implementation LLAVFrame
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (NSTimeInterval)getPts {
    return self.ptsSec;
}

- (int)getW {
    return _frame->width;
}
- (int)getH {
    return _frame->height;
}

- (int)getYUV_Y:(char *)YUV_y {
    
    int w = [self getW];
    int h = [self getW];
    
    for (NSInteger i = 0; i < h; i++) {
        memcpy(YUV_y + i * w, _frame->data[0] + _frame->linesize[0] * i, w);
    }
    
    return 0;
}

- (int)getYUV_U:(char *)YUV_u {
    int w = [self getW] / 2;
    int h = [self getW] / 2;
    
    for (NSInteger i = 0; i < h; i++) {
        memcpy(YUV_u + i * w, _frame->data[1] + _frame->linesize[1] * i, w);
    }
    return 0;
}

- (int)getYUV_V:(char *)YUV_v {
    int w = [self getW] / 2;
    int h = [self getW] / 2;
    
    for (NSInteger i = 0; i < h; i++) {
        memcpy(YUV_v + i * w, _frame->data[2] + _frame->linesize[2] * i, w);
    }
    return 0;
}

- (void)printAudioFrame {
    NSLog(@"audio.channels:%d",_frame->channels);
    NSLog(@"audio.nb_samples:%d",_frame->nb_samples);
    NSLog(@"audio.sample_rate:%d",_frame->sample_rate);
    
    enum AVSampleFormat format = _frame->format;
    char *str = malloc(128);
    av_get_sample_fmt_string(str, 128, format);
    NSLog(@"audio.format:%s",str);
    free(str);
    
    for (NSInteger i = 0; i < AV_NUM_DATA_POINTERS; i++) {
        NSLog(@"audio.linesize[%ld]:%d",(long)i,_frame->linesize[i]);
    }
}

- (void)printVideoFrame {
    NSLog(@"video.width:%d",_frame->width);
    NSLog(@"video.height:%d",_frame->height);
    
    enum AVPixelFormat format = _frame->format;
    char *str = malloc(128);
    av_get_pix_fmt_string(str, 128, format);
    NSLog(@"video.format:%s",str);
    free(str);
    
    for (NSInteger i = 0; i < AV_NUM_DATA_POINTERS; i++) {
        NSLog(@"video.linesize[%ld]:%d",(long)i,_frame->linesize[i]);
    }
}

- (void)setup {
    _frame = av_frame_alloc();
}

- (void)dealloc {
    if (_frame) {
        av_frame_free(&_frame);
        _frame = nil;
    }
}
@end
