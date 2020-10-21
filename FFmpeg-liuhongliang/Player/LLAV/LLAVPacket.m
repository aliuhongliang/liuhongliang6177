//
//  LLAVPacket.m
//  FFmpeg-liuhongliang
//
//  Created by 刘宏亮 on 2020/10/18.
//  Copyright © 2020 刘宏亮. All rights reserved.
//

#import "LLAVPacket.h"

@implementation LLAVPacket
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (NSInteger)streamIndex {
    return _pkt->stream_index;
}

- (void)setup {
    _pkt = av_packet_alloc();
}

- (void)dealloc {
    if (_pkt) {
        av_packet_free(&_pkt);
        _pkt = nil;
    }
}
@end
